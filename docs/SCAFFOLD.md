# Scaffold analysis and delivery record

Date: 2026-10-02. Scope: the requested scaffold, based on the supplied 1 October implementation plan.

## Analysis of the plan

The dependency order is sound: establish native module/storage boundaries, build one authoritative
timer and measured ledger, validate a small audio engine, then add statistics and platform features.
The reference analysis is sufficient for a shell. It does not establish acoustic equivalence, duration
bounds, browser support, private-mode behavior or screen-lock behavior. Those cannot become assumed
implementation facts. Live Endel inspection remains deferred.

Step 2 combines ordinary scaffolding with several substantial feasibility experiments. This delivery
implements the project, native build, interfaces, first schema and test infrastructure, plus the
navigable shell from Step 3. It does **not** mark either entire step complete. Browser signing/privacy
experiments, real sleep/session testing and the full accessibility/OS matrix remain explicit gates.

The plan's proposed monolith is retained: one application, four packages, no per-screen packages,
backend, CloudKit, generic workflow layer or custom DSP. The domain remains free of SwiftUI,
SwiftData and AppKit. A single composition root owns shared observable app state and dependencies.
There is no session coordinator yet because no timer is running. Step 4 must introduce the single
reducer there, rather than starting timers in views.

## Delivered scope

| Scaffold requirement | Implementation/evidence |
| --- | --- |
| Native Xcode app and package layout | `FlowState.xcodeproj`, shared FlowState scheme, `App/`, `Features/`, four `Packages/`, `Tests/`, `Resources/Audio/`, `docs/adr/` |
| Strict concurrency and compatibility target | Swift 6 language mode; complete concurrency checking; macOS 15 target; no macOS 26/27-only API use |
| Deliberate sandbox | App Sandbox entitlement only in source; no network, Automation, microphone, recording, sync or login capability |
| Composition and injectable boundaries | AppModel receives repository factory, clock, audio and lifecycle adapters; repository opens away from the main actor |
| Deterministic testing infrastructure | TestClock separates monotonic elapsed and wall time; lifecycle/audio mock adapters; Swift Testing test suite |
| First versioned local store | V1 finalized session metadata and Focus tuning; explicit migration plan; no CloudKit; actor isolation; rollback on failed save |
| Safe persistence behavior | Immutable stable session IDs, repeat insert is a no-op, conflicts fail; invalid values rejected; failed open does not erase data |
| Native shell | Dashboard, Sound Library, Insights, History, Settings, menu bar, onboarding and local appearance preference |
| Usable scaffold behavior | Apply/Cancel for saved tuning; native Settings shortcut; explicit Quit; dashboard can close independently |
| Honest empty states | Timer Start disabled; no playing sound, fake totals, catalog playback tiles or collected activity |
| Tooling | Deterministic Python project generator, swift-format config, check script, macOS CI workflow, dependency/license inventory |
| Diagnostic privacy | Only store errors logged, dynamically interpolated error content marked private; no activity/tuning values logged |

Only finalized session metadata and tuning are persisted in V1. Active segments, recovery checkpoints,
events, sound intervals, mode versions and app/domain slices remain later schema work. No chart can
claim trustworthy focus time before the ledger exists. The first migration plan intentionally has no
stages; there is no earlier production store to migrate.

## Feature traceability

| Plan feature IDs | Scaffold surface or boundary | Implementation still due |
| --- | --- | --- |
| T01–T04 | Dashboard, reference 50/10/20 preset | Step 4 timer/reducer/ledger, duration specification and cycle rules |
| M01–M03 | MenuBarExtra, navigation, explicit Quit | Steps 5/9 live countdown, shortcuts, Dock/login behavior, eight styles |
| N01–N04 | Permission-free MacIntegration boundary | Steps 9/10 notifications, overlay, nudges and reminders |
| H01–H05 | Insights and History empty states | Steps 8/11–13 measured statistics, attribution and share cards |
| P01 | Onboarding, system/light/dark, Settings and Help | Full keyboard/VoiceOver and supported-OS review |
| P02–P03 | Local store and no account/network dependency | Operational timer/history, retention and export/import/reset in later steps |
| X01–X02 | No enabled capability; retained in plan | Steps 16/17 optional sync, business/distribution decision and purchase |
| A01–A04 | Focus tuning sliders and AudioControlling boundary | Steps 6/7/14 actual engine, recipes, Apply preview, adaptation and catalog |
| I01–I02 | Domain/audio separation | Steps 7/8 timer-linked sound and sound usage accounting |

## Verification

Local toolchain: Xcode 27.0 (27A266a), Apple Swift 6.4 (swiftlang-6.4.0.34.1), Apple Silicon,
macOS 27.0.1 (26A434). Full Xcode is now selected, superseding the earlier plan's CommandLineTools
finding. Minimum deployment target is 15.0; a target setting is not proof of runtime behavior on 15/26.

Run `bash scripts/check.sh` for formatting, package tests, native Debug build, signature integrity and
property-list validation. The UI test target is run separately in a logged-in session. Local evidence
is summarized in `docs/VERIFICATION.md` after the final checks.

There is no hosted repository/CI run attached to this workspace. The workflow is configured and its
commands are checked locally; hosted CI is unverified. Zero remote Swift dependencies means no real
SwiftPM pins or generated lockfile exist yet; see `DEPENDENCIES.md`. The plan's license and pinning
requirement applies when a remote dependency is introduced.

## Next implementation

Resolve timer duration bounds/increments, then implement Step 4's reducer, measured segments,
checkpoints and recovery tests through the existing repository/clock boundaries. Keep manual phase
transitions and preserve interrupted work. In parallel with later feature work, run the explicit
permission/lifecycle experiments in `EXPERIMENTS.md` before committing to browser support or a
distribution channel. Do not enable production permission requests just to demonstrate the shell.
