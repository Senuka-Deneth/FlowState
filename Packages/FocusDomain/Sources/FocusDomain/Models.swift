import Foundation

public enum SessionPhase: String, Codable, CaseIterable, Sendable {
    case focus, shortBreak, longBreak
}

public enum SessionStatus: String, Codable, Sendable {
    case idle, running, paused, awaitingNext, recovery
}

public enum SessionOutcome: String, Codable, Sendable {
    case completed, interrupted
}

public enum DomainValidationError: Error, Equatable {
    case invalidTuning
    case invalidSession
}

/// Captured reference values, not a claim about the reference app's factory defaults.
public struct TimerConfiguration: Equatable, Sendable {
    public let focusSeconds: Int
    public let shortBreakSeconds: Int
    public let longBreakSeconds: Int
    public let blocksPerCycle: Int

    public static let reference = TimerConfiguration(
        focusSeconds: 3000, shortBreakSeconds: 600, longBreakSeconds: 1200, blocksPerCycle: 4
    )
}

/// Validated values cross the repository boundary; SwiftData models never escape it.
public struct FocusTuning: Equatable, Sendable {
    public let structure: Double
    public let intensity: Double

    public init(structure: Double, intensity: Double) throws {
        guard structure.isFinite, intensity.isFinite,
            (0...1).contains(structure), (0...1).contains(intensity)
        else { throw DomainValidationError.invalidTuning }
        self.structure = structure
        self.intensity = intensity
    }

    public static let neutral = try! FocusTuning(structure: 0.5, intensity: 0.5)
}

/// Finalized phase metadata only. Step 4 adds the measured segment ledger and checkpoints.
/// Do not derive focus time from these wall-clock boundaries.
public struct SessionRecord: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let phase: SessionPhase
    public let startedAt: Date
    public let endedAt: Date
    public let plannedSeconds: Int
    public let outcome: SessionOutcome
    public let reportingTimeZone: String

    public init(
        id: UUID = UUID(), phase: SessionPhase, startedAt: Date, endedAt: Date,
        plannedSeconds: Int, outcome: SessionOutcome, reportingTimeZone: String
    ) throws {
        guard startedAt.timeIntervalSince1970.isFinite, endedAt.timeIntervalSince1970.isFinite,
            endedAt >= startedAt, plannedSeconds > 0,
            TimeZone(identifier: reportingTimeZone) != nil
        else { throw DomainValidationError.invalidSession }
        self.id = id
        self.phase = phase
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.plannedSeconds = plannedSeconds
        self.outcome = outcome
        self.reportingTimeZone = reportingTimeZone
    }
}
