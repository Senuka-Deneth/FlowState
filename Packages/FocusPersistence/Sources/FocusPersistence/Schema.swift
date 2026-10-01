import Foundation
import SwiftData

public enum FocusSchemaV1: VersionedSchema {
    public static let versionIdentifier = Schema.Version(1, 0, 0)
    public static var models: [any PersistentModel.Type] {
        [StoredSession.self, StoredTuning.self]
    }

    @Model
    public final class StoredSession {
        @Attribute(.unique) public var id: UUID
        public var phase: String
        public var startedAt: Date
        public var endedAt: Date
        public var plannedSeconds: Int
        public var outcome: String
        public var reportingTimeZone: String

        public init(
            id: UUID, phase: String, startedAt: Date, endedAt: Date,
            plannedSeconds: Int, outcome: String, reportingTimeZone: String
        ) {
            self.id = id
            self.phase = phase
            self.startedAt = startedAt
            self.endedAt = endedAt
            self.plannedSeconds = plannedSeconds
            self.outcome = outcome
            self.reportingTimeZone = reportingTimeZone
        }
    }

    @Model
    public final class StoredTuning {
        @Attribute(.unique) public var modeID: String
        public var structure: Double
        public var intensity: Double

        public init(modeID: String, structure: Double, intensity: Double) {
            self.modeID = modeID
            self.structure = structure
            self.intensity = intensity
        }
    }
}

public enum FocusMigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] { [FocusSchemaV1.self] }
    public static var stages: [MigrationStage] { [] }
}
