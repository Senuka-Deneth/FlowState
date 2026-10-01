# FlowState

A native macOS focus app scaffold based on the [implementation plan](outputs/IMPLEMENTATION_PLAN.md).
Minimum deployment target: macOS 15. Swift 6 language mode
and strict concurrency are enabled. No external Swift dependencies are required.

## Open and run

Open `FlowState.xcodeproj` in full Xcode, choose the **FlowState** scheme and **My Mac**, then Run.
Local builds use ad-hoc signing with App Sandbox enabled; no developer account is required for this
scaffold. Distribution signing and notarization are separate work.

```sh
xcodebuild -project FlowState.xcodeproj -scheme FlowState \
  -destination 'platform=macOS' -derivedDataPath .build/xcode build
open .build/xcode/Build/Products/Debug/FlowState.app
```

The Dashboard, Sound Library, Insights, History, Settings, onboarding and menu bar are navigable.
Appearance and Focus tuning persist locally. Closing the dashboard leaves the menu bar running;
Quit exits the app. There is no working timer, sound engine, activity collection or fabricated history.
Apply saves tuning; Cancel restores saved values. The future audio preview contract is not implemented.

## Verify

```sh
bash scripts/check.sh
# UI automation requires a logged-in graphical session and Xcode's testing authorization.
xcodebuild -project FlowState.xcodeproj -scheme FlowState \
  -destination 'platform=macOS' -derivedDataPath .build/xcode test
```

`swift test` covers clock separation, input validation, empty storage, idempotency/conflicts,
disk reopening, storage-path failure, lifecycle mocks and unavailable audio. It runs without opening
the app. UI smoke tests use an in-memory database and a separate preference suite. The relaunch test
uses a uniquely named temporary on-disk store and preference suite, isolated from normal app data.

Use `xcrun swift-format format --in-place --recursive App Features Packages Tests Package.swift`
to format. The checked-in project is generated with Python's standard library; after adding/removing
app or UI-test Swift files, run `python3 scripts/generate_project.py`. No project generator installation
or package download is needed. Edit that generator when changing Xcode build settings.

## Structure

| Location | Responsibility |
| --- | --- |
| `App/` | Single composition root, observable UI state, preferences, scenes, entitlements |
| `Features/` | Native screen shell and explicitly unavailable future controls |
| `Packages/FocusDomain/` | Validated values, repository and time interfaces; no UI or persistence framework |
| `Packages/FocusPersistence/` | SwiftData V1 schema, migration plan, isolated repository |
| `Packages/FocusAudio/` | Asynchronous control boundary, explicit unavailable implementation |
| `Packages/MacIntegration/` | Supported workspace lifecycle notifications; no permission requests |
| `Tests/` | Foundation tests, deterministic clock, mocks and Xcode UI test |
| `Resources/Audio/` | Future asset/recipe rights inventory |
| `docs/` | Scaffold analysis, validation record, ADRs and outstanding experiments |

The first schema stores finalized session metadata and Focus tuning. Measured segments, recovery
checkpoints, audio intervals and statistics belong to later steps; never infer focus duration from
session wall timestamps. Future schema changes require a new schema version and migration fixture.
Opening a failed store does not reset it or silently substitute temporary storage.

See [scaffold analysis and verification](docs/SCAFFOLD.md) and
[permission/lifecycle experiments](docs/EXPERIMENTS.md) for scope and remaining gates.

## App identity

The app, Xcode project and scheme are named **FlowState**. The original bundle identifier
`dev.focusapp.scaffold` and SwiftData configuration key `FocusApp` are intentionally stable so this
rename preserves the existing sandbox, preferences and saved tuning. The `FocusDomain`,
`FocusPersistence` and `FocusAudio` packages describe their responsibilities and retain their names.
