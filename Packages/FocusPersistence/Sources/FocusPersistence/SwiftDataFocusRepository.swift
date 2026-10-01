import FocusDomain
import Foundation
import SwiftData

public enum RepositoryError: Error {
    case conflictingSessionID
    case unsupportedStoredValue
}

@ModelActor
public actor SwiftDataFocusRepository: FocusRepository {
    public static func open(at url: URL? = nil, inMemory: Bool = false) throws
        -> SwiftDataFocusRepository
    {
        let schema = Schema(versionedSchema: FocusSchemaV1.self)
        let configuration: ModelConfiguration
        if let url {
            try FileManager.default.createDirectory(
                at: url.deletingLastPathComponent(), withIntermediateDirectories: true
            )
            configuration = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)
        } else {
            // Stable on-disk store key from the original scaffold; preserve saved data across renames.
            configuration = ModelConfiguration(
                "FocusApp", schema: schema, isStoredInMemoryOnly: inMemory, cloudKitDatabase: .none
            )
        }
        let container = try ModelContainer(
            for: schema, migrationPlan: FocusMigrationPlan.self, configurations: [configuration]
        )
        return SwiftDataFocusRepository(modelContainer: container)
    }

    public func sessions() throws -> [SessionRecord] {
        try modelContext.fetch(
            FetchDescriptor<FocusSchemaV1.StoredSession>(sortBy: [
                SortDescriptor(\.startedAt, order: .reverse)
            ])
        ).map(Self.record)
    }

    public func insertSession(_ record: SessionRecord) throws {
        let id = record.id
        let matches = try modelContext.fetch(
            FetchDescriptor<FocusSchemaV1.StoredSession>(predicate: #Predicate { $0.id == id })
        )
        if let existing = matches.first {
            guard try Self.record(existing) == record else {
                throw RepositoryError.conflictingSessionID
            }
            return
        }
        modelContext.insert(
            FocusSchemaV1.StoredSession(
                id: record.id, phase: record.phase.rawValue,
                startedAt: record.startedAt, endedAt: record.endedAt,
                plannedSeconds: record.plannedSeconds, outcome: record.outcome.rawValue,
                reportingTimeZone: record.reportingTimeZone
            )
        )
        try commit()
    }

    public func focusTuning() throws -> FocusTuning? {
        guard let stored = try storedTuning() else { return nil }
        return try FocusTuning(structure: stored.structure, intensity: stored.intensity)
    }

    public func saveFocusTuning(_ tuning: FocusTuning) throws {
        if let stored = try storedTuning() {
            stored.structure = tuning.structure
            stored.intensity = tuning.intensity
        } else {
            modelContext.insert(
                FocusSchemaV1.StoredTuning(
                    modeID: "focus", structure: tuning.structure, intensity: tuning.intensity
                )
            )
        }
        try commit()
    }

    private func storedTuning() throws -> FocusSchemaV1.StoredTuning? {
        try modelContext.fetch(
            FetchDescriptor<FocusSchemaV1.StoredTuning>(
                predicate: #Predicate { $0.modeID == "focus" })
        ).first
    }

    private func commit() throws {
        do { try modelContext.save() } catch {
            modelContext.rollback()
            throw error
        }
    }

    private static func record(_ stored: FocusSchemaV1.StoredSession) throws -> SessionRecord {
        guard let phase = SessionPhase(rawValue: stored.phase),
            let outcome = SessionOutcome(rawValue: stored.outcome)
        else { throw RepositoryError.unsupportedStoredValue }
        return try SessionRecord(
            id: stored.id, phase: phase, startedAt: stored.startedAt, endedAt: stored.endedAt,
            plannedSeconds: stored.plannedSeconds, outcome: outcome,
            reportingTimeZone: stored.reportingTimeZone
        )
    }
}
