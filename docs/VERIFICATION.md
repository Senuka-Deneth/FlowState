# Scaffold verification

Verified locally on 2 October 2026, macOS 27.0.1 (26A434), Apple Silicon,
Xcode 27.0 (27A266a), Swift 6.4. Deployment target: macOS 15.0.

| Check | Result | Evidence |
| --- | --- | --- |
| Strict source formatting | Pass | `xcrun swift-format lint --strict --recursive App Features Packages Tests Package.swift` |
| Foundation suite | Pass: 9 test functions, including 4 invalid-tuning parameter cases | `swift test`; zero failures |
| SwiftData durability | Pass | Disk-store recreation test and actual app quit/relaunch UI test |
| Session IDs | Pass | Repeated immutable insert produces one record; conflicting data cannot overwrite it |
| Invalid/unavailable storage | Pass | Invalid values rejected; invalid store parent throws; no automatic data reset |
| UI navigation | Pass | Onboarding → Dashboard → Sound Library → Insights → History → Settings via ⌘, |
| UI persistence | Pass | Enter 75% structure with keyboard, Apply, terminate, relaunch, confirm 75% and dismissed onboarding |
| Close-window behavior | Pass | ⌘W removes dashboard window; app process remains running |
| UI suite | Pass: 2 tests | `.build/ScaffoldDeliveryTests.xcresult`, 0 failures |
| Debug native build | Pass | `bash scripts/check.sh` includes native build, signature and plist validation |
| Release universal build | Pass | `xcodebuild ... -configuration Release -destination 'generic/platform=macOS' -derivedDataPath .build/release build` |
| Release architectures | Pass | `lipo -archs` reports `x86_64 arm64`; execution was tested only on Apple Silicon |
| Release signature integrity | Pass | `codesign --verify --deep --strict` |
| Release effective entitlements | Pass | `codesign -d --entitlements :-` contains only `com.apple.security.app-sandbox = true` |
| Project generation | Pass | Regeneration produces identical project and scheme content |
| Native visual review | Pass for captured screens on this Mac | [Dashboard](evidence/dashboard.png), [Sound tuning](evidence/sound-tuning.png) |

The ordinary Release app was opened from `.build/release/Build/Products/Release/FlowState.app` after
checks. It is a local ad-hoc signed build, not a notarized or distribution-signed artifact. Xcode's
UI testing build temporarily injects testing/debug exceptions; these are absent from the Release
entitlements above. Hardened runtime still requires a suitable distribution signing identity.

The UI test uses a uniquely named temporary store and preference suite to avoid altering ordinary
app data. It proves saved tuning and onboarding survive an actual process restart. The separate
foundation test proves finalized session metadata survives a store reopen without seeding user history.

## Not verified or not implemented

- Hosted CI execution: workflow exists, but this workspace has no connected Git repository/remote.
- Runtime compatibility on macOS 15/26, Intel hardware, light appearance, VoiceOver, reduced
  motion/transparency, multiple displays and repeated menu-bar reopen behavior.
- Physical sleep, user switching and screen-lock signal behavior; mocks are not OS experiments.
- Signed browser/Automation denial, revocation and private-window experiments. No valid development
  signing identity is configured, and no browser adapter or permission request is implemented.
- Timer, durable measured segments, crash recovery, statistics, retention, sound playback, listening
  quality, notifications, shortcuts, login control, optional sync and commerce.

These are retained in the implementation plan. This record establishes completion of the requested
scaffold, not completion of the full Step 2/3 exit gates or the product.

## FlowState rename verification — 2 October 2026

The product, source entry point, entitlements file, Xcode project/scheme, UI labels, test
environment keys, scripts and documentation now use FlowState. The original app bundle identifier
and SwiftData configuration key remain stable to retain existing local data.

After the rename, `scripts/check.sh` passed (formatting, nine foundation tests, Debug build,
signature and plist checks). Both UI tests passed, including saved tuning across relaunch and
window-close behavior; results are in `.build/FlowStateRenameTests.xcresult`. The universal
Release build passed with `x86_64 arm64` slices, and its signature verified successfully.
Project regeneration is deterministic; the old source/project/scheme filenames are absent.
