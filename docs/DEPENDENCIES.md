# Dependency and license inventory

The scaffold uses the macOS SDK and four first-party local Swift packages. There are **zero remote
Swift packages** and no third-party audio assets. SwiftPM does not produce `Package.resolved` when
there are no remote pins; an invented lockfile would not lock anything. Local package contents are
versioned alongside the app. The Xcode project generator uses only Python's standard library.

Step 5 may add KeyboardShortcuts after selecting an exact release and reviewing compatibility/license.
At that point commit the generated Xcode workspace `Package.resolved`, use an exact package version,
and add the license here. Do not introduce that dependency just to populate a lockfile.

CI pins `actions/checkout` v4.2.2 by commit (MIT license) and selects Xcode 26.3 on `macos-15`.
Its availability was checked against the [official runner image inventory](https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md).
Each run prints the exact Xcode, Swift and OS versions. The local build was verified with Xcode 27.0;
CI compatibility is not claimed until a hosted run completes.

The privacy manifest declares local app preferences using UserDefaults reason CA92.1. See
[Apple's required-reason API documentation](https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api).
Review the manifest when introducing additional APIs. No tracking, data upload, microphone, screen
capture, network, Automation, login item or CloudKit capability is enabled here.
