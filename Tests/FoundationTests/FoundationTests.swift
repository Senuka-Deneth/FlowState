import FocusAudio
import FocusDomain
import FocusPersistence
import Foundation
import MacIntegration
import Testing

actor TestClock: TimeSource {
    private var wallTime = Date(timeIntervalSince1970: 1_000)
    private var elapsed = Duration.zero

    func read() -> ClockReading { ClockReading(wallTime: wallTime, elapsed: elapsed) }
    func advance(seconds: Int) {
        wallTime.addTimeInterval(Double(seconds))
        elapsed += .seconds(seconds)
    }
    func changeWallClock(seconds: Int) { wallTime.addTimeInterval(Double(seconds)) }
}

actor MockAudioController: AudioControlling {
    private(set) var prepared: [FocusTuning] = []
    private(set) var stopCount = 0
    func prepare(tuning: FocusTuning) { prepared.append(tuning) }
    func stop() { stopCount += 1 }
}

@MainActor
final class MockLifecycleObserver: LifecycleObserving {
    private var receive: (@MainActor @Sendable (LifecycleEvent) -> Void)?
    func start(_ receive: @escaping @MainActor @Sendable (LifecycleEvent) -> Void) {
        self.receive = receive
    }
    func stop() { receive = nil }
    func emit(_ event: LifecycleEvent) { receive?(event) }
}

@Test func elapsedTimeIsIndependentOfWallClockAdjustments() async {
    let clock = TestClock()
    await clock.advance(seconds: 30)
    await clock.changeWallClock(seconds: -3600)
    let reading = await clock.read()
    #expect(reading.elapsed == .seconds(30))
    #expect(reading.wallTime == Date(timeIntervalSince1970: -2570))
}

@Test(arguments: [-0.01, 1.01, Double.nan, Double.infinity])
func invalidTuningIsRejected(value: Double) {
    #expect(throws: DomainValidationError.invalidTuning) {
        try FocusTuning(structure: value, intensity: 0.5)
    }
    #expect(throws: DomainValidationError.invalidTuning) {
        try FocusTuning(structure: 0.5, intensity: value)
    }
}

@Test func invalidSessionIsRejected() {
    #expect(throws: DomainValidationError.invalidSession) {
        try SessionRecord(
            phase: .focus, startedAt: Date(timeIntervalSince1970: 100),
            endedAt: Date(timeIntervalSince1970: 99), plannedSeconds: 3000,
            outcome: .interrupted, reportingTimeZone: "UTC"
        )
    }
}

private func fixture(id: UUID = UUID(), plannedSeconds: Int = 3000) throws -> SessionRecord {
    try SessionRecord(
        id: id, phase: .focus, startedAt: Date(timeIntervalSince1970: 100),
        endedAt: Date(timeIntervalSince1970: 160), plannedSeconds: plannedSeconds,
        outcome: .interrupted, reportingTimeZone: "Asia/Colombo"
    )
}

@Test func emptyStoreDoesNotManufactureHistory() async throws {
    let repository = try SwiftDataFocusRepository.open(inMemory: true)
    #expect(try await repository.sessions().isEmpty)
    #expect(try await repository.focusTuning() == nil)
}

@Test func repeatedInsertsAreIdempotentAndConflictsDoNotOverwrite() async throws {
    let repository = try SwiftDataFocusRepository.open(inMemory: true)
    let record = try fixture()
    try await repository.insertSession(record)
    try await repository.insertSession(record)
    let conflicting = try fixture(id: record.id, plannedSeconds: 600)
    await #expect(throws: RepositoryError.conflictingSessionID) {
        try await repository.insertSession(conflicting)
    }
    #expect(try await repository.sessions() == [record])
}

private func writeStore(at url: URL, record: SessionRecord, tuning: FocusTuning) async throws {
    let repository = try SwiftDataFocusRepository.open(at: url)
    try await repository.insertSession(record)
    try await repository.saveFocusTuning(.neutral)
    try await repository.saveFocusTuning(tuning)
}

@Test func versionedDiskStoreSurvivesRepositoryRecreation() async throws {
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: directory) }
    let url = directory.appendingPathComponent("Focus.store")
    let record = try fixture()
    let tuning = try FocusTuning(structure: 0.2, intensity: 0.8)
    try await writeStore(at: url, record: record, tuning: tuning)
    let reopened = try SwiftDataFocusRepository.open(at: url)
    #expect(try await reopened.sessions() == [record])
    #expect(try await reopened.focusTuning() == tuning)
}

@Test func unwritableStoreReportsFailure() {
    #expect(throws: (any Error).self) {
        try SwiftDataFocusRepository.open(at: URL(fileURLWithPath: "/dev/null/Focus.store"))
    }
}

@Test func scaffoldAudioDoesNotPretendToPlay() async {
    let audio = UnavailableAudioController()
    await #expect(throws: AudioError.engineNotImplemented) {
        try await audio.prepare(tuning: .neutral)
    }
}

@Test @MainActor func stoppedMockDoesNotDeliverLifecycleEvents() {
    let observer = MockLifecycleObserver()
    var received = 0
    observer.start { _ in received += 1 }
    observer.emit(.willSleep)
    observer.stop()
    observer.emit(.didWake)
    #expect(received == 1)
}
