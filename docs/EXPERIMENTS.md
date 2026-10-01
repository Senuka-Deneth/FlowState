# Permission and lifecycle experiments

Date: 2026-10-02. This is a scaffold readiness record, not a completed browser compatibility matrix.

| Experiment | Current evidence | Remaining work |
| --- | --- | --- |
| Core permissions | Entitlements contain only App Sandbox. No API requests Automation, notifications, microphone, input recording, location or login access. | Repeat fresh-install smoke check on each supported OS. |
| Browser domain access | No browser adapter exists or runs. `security find-identity -v -p codesigning` reports 0 valid identities. | Use a separately signed opt-in spike to test intended distribution channels; no domain support can be claimed. |
| Denial/revocation | No production capability requests exist. | For each chosen browser, record fresh grant, denial, revocation, timeout, closed browser, and safe fallback. |
| Private-window detection | Unimplemented and unsupported. | Prove reliable private-mode detection per browser before enabling any domain collection. |
| System sleep/wake | Adapter compiles against supported NSWorkspace willSleep/didWake notifications. | Test real sleep/wake on macOS 15/26/27 with a timer; a mock event is not proof of OS delivery. |
| User-session changes | Adapter compiles against sessionDidResignActive/sessionDidBecomeActive notifications. | Test fast user switching and session transitions on target versions. |
| Screen lock | No lock adapter and no unsupported distributed-notification strings. | Establish a supported signal; display sleep is not treated as lock. |

For each later run, record OS/build, hardware, signed bundle identifier/team, entitlements, browser
version, distribution channel, input actions, expected signal, observed signal and timing, and fallback.
Do not store URLs, titles, or private browsing content as diagnostic evidence. Keep detailed activity
local. The scaffold observes lifecycle changes only in memory and has no running timer to pause.

Browser support remains unavailable for Safari, Chrome and all derivatives until measured separately.
No live Endel inspection was attempted; that deferral in the supplied plan remains in force.
