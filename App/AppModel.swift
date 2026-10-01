import FocusAudio
import FocusDomain
import FocusPersistence
import Foundation
import MacIntegration
import OSLog
import Observation

enum AppSection: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case sounds = "Sound Library"
    case insights = "Insights"
    case history = "History"

    var id: Self { self }
    var symbol: String {
        switch self {
        case .dashboard: "timer"
        case .sounds: "waveform"
        case .insights: "chart.bar.xaxis"
        case .history: "clock.arrow.circlepath"
        }
    }
}

@MainActor @Observable
final class AppModel {
    var selection: AppSection? = .dashboard
    private(set) var sessions: [SessionRecord] = []
    private(set) var savedTuning = FocusTuning.neutral
    private(set) var storageReady = false
    private(set) var isLoading = false
    private(set) var isSaving = false
    private(set) var storageError = false
    private(set) var lastLifecycleEvent: LifecycleEvent?
    private(set) var launchReading: ClockReading?
    private var repository: (any FocusRepository)?
    private let repositoryFactory: @Sendable () throws -> any FocusRepository
    private let clock: any TimeSource
    private let audio: any AudioControlling
    private let lifecycle: any LifecycleObserving
    private let logger = Logger(subsystem: "dev.focusapp.scaffold", category: "storage")

    init(
        repositoryFactory: @escaping @Sendable () throws -> any FocusRepository,
        clock: any TimeSource, audio: any AudioControlling, lifecycle: any LifecycleObserving
    ) {
        self.repositoryFactory = repositoryFactory
        self.clock = clock
        self.audio = audio
        self.lifecycle = lifecycle
    }

    func start() async {
        guard !storageReady, !isLoading else { return }
        isLoading = true
        storageError = false
        defer { isLoading = false }
        lifecycle.start { [weak self] event in self?.lastLifecycleEvent = event }
        launchReading = await clock.read()
        do {
            let factory = repositoryFactory
            let opened = try await Task.detached { try factory() }.value
            let loadedSessions = try await opened.sessions()
            let tuning = try await opened.focusTuning()
            repository = opened
            sessions = loadedSessions
            savedTuning = tuning ?? .neutral
            storageReady = true
        } catch {
            storageError = true
            // Error text can contain paths or user data. Keep it private even in debug logs.
            logger.error("Store could not open: \(String(describing: error), privacy: .private)")
        }
    }

    func saveTuning(_ tuning: FocusTuning) async -> Bool {
        guard let repository, !isSaving else { return false }
        isSaving = true
        defer { isSaving = false }
        do {
            try await repository.saveFocusTuning(tuning)
            savedTuning = tuning
            storageError = false
            return true
        } catch {
            storageError = true
            logger.error("Tuning save failed: \(String(describing: error), privacy: .private)")
            return false
        }
    }
}
