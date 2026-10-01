# ADR-001 — Native scaffold and dependency direction

Date: 2026-10-02. Status: accepted for scaffold.

Use a SwiftUI macOS app with four local Swift packages, Swift 6 concurrency checking and a macOS 15
deployment target. App creates and injects all dependencies. Features depend on observable app state;
FocusDomain depends only on Foundation. Persistence and audio depend on domain, never on views.
MacIntegration contains the AppKit boundary. No service locator or per-screen timer is introduced.

SwiftData models stay behind a model actor and return immutable Sendable domain values. Schema V1
contains only finalized session metadata and saved Focus tuning. Metadata is not a focus-time ledger.
SchemaMigrationPlan starts at V1 with no migration stages, because no previous store version exists.

This instantiates plan ADR-001/002/007/008. Plan ADR-003/004 will be implemented with the reducer,
segments and checkpoints in Step 4. ADR-005 guides later original audio work. ADR-006 is preserved by
omitting tracking entirely and reserving permission requests for an explicit opt-in.

The project is checked in and generated deterministically without third-party project tooling.
Ad-hoc signing supports local sandbox verification; it does not establish Developer ID, notarization
or App Store suitability. Xcode disables hardened runtime for ad-hoc builds despite the intended
release setting. Distribution signing is an explicit later decision.
