import Foundation

public protocol FocusRepository: Sendable {
    func sessions() async throws -> [SessionRecord]
    /// Repeating the same immutable record is safe; conflicting IDs must fail.
    func insertSession(_ record: SessionRecord) async throws
    func focusTuning() async throws -> FocusTuning?
    func saveFocusTuning(_ tuning: FocusTuning) async throws
}

public struct ClockReading: Equatable, Sendable {
    public let wallTime: Date
    /// Only meaningful within this clock instance's lifetime. Never persist this value.
    public let elapsed: Duration

    public init(wallTime: Date, elapsed: Duration) {
        self.wallTime = wallTime
        self.elapsed = elapsed
    }
}

public protocol TimeSource: Sendable {
    func read() async -> ClockReading
}

public struct SystemTimeSource: TimeSource {
    private let origin = ContinuousClock.now

    public init() {}

    public func read() async -> ClockReading {
        ClockReading(wallTime: Date(), elapsed: origin.duration(to: .now))
    }
}
