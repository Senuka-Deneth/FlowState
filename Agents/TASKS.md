# Agent task checklist

Updated: 2 October 2026. This file is the authoritative implementation checklist for FlowState.
Read [AGENTS.md](../AGENTS.md), [agent workflow](README.md), the [implementation plan](../outputs/IMPLEMENTATION_PLAN.md), and the relevant Graphify context before changing implementation.

Check a task only after its entire scope, validation and Graphify update pass. Record evidence in [COMPLETION_LOG.md](COMPLETION_LOG.md). A scaffold or partial implementation does not satisfy a whole task. Deferred and blocked items remain unchecked. Original Step 1–17 completion marks are preserved; no new application features are claimed implemented by this planning update.

## Agent workflow setup

- [x] Locate the renamed FlowState workspace and preserve existing scaffold completion marks.
- [x] Consolidate the complete implementation backlog here, add authentication scope, and create persistent checklist/Graphify rules.
- [x] Document Supabase configuration inputs and account architecture without embedding credentials.
- [ ] Build the initial Graphify graph for project code and planning documents before the next implementation; verify query output and save graph/report/HTML provenance.

## Decisions and external setup needed for Step 18

- [ ] User chooses whether login is mandatory or local use is allowed without an account. Do not infer the answer from a preselected option.
- [ ] User chooses email/password or passwordless email OTP/magic link; implement the selected method's complete verification/recovery flows.
- [ ] User supplies Supabase Project URL and publishable key; confirm development/production configuration separation.
- [ ] Confirm release bundle ID, Apple Developer Team ID and native callback URL. Current `dev.focusapp.scaffold` is a scaffold identifier, not an approved production identity.
- [ ] User configures Google provider in Supabase/Google Cloud and Apple native capability/provider audiences. Provider secrets stay in provider dashboards or server secret storage.
- [ ] Configure custom SMTP and verified sender for external-user emails; record delivery and Apple relay tests before release.
- [ ] Decide sign-out/account-switch handling, local data ownership/guest-history adoption if guest mode is chosen, and account deletion behavior before changing persistence.

## Product implementation checklist

Every step has a concrete exit condition. Existing completion marks are preserved from the implementation plan; unchecked items include partial work whose acceptance gate has not passed. Step numbers are stable identifiers; follow the dependency diagram rather than numeric order.

### Step 1 — Close reference gaps and freeze scope

- [x] Inspect all six supplied files; preserve filenames/checksums, screenshot findings and sampled-video observations in the reference analysis and inventory.
- [ ] Deferred by user choice: live Endel inspection. Audit accessible controls/modes only after a future authorized browser session succeeds.
- [x] Incorporate observed controls and explicitly separate them from proposed behavior and remaining unknowns.
- [x] Preserve findings and checksums, verify the six regular files, and move only Reference-Src to Trash. See [cleanup record](../outputs/reference-cleanup.json); original workspace path is absent.

**Exit:** saved traceability and cleanup records, with the live audit and exact audio gaps explicitly deferred. No claim of complete parity. Before an implementation decision depends on missing evidence, surface the gap rather than inventing reference behavior.

### Step 2 — Establish project, native build and persistence boundaries

- [x] Install/select a full stable Xcode if needed; record toolchain and deployment target. Xcode 27.0 is now selected; macOS 15 deployment target.
- [x] Create the Xcode macOS app and local packages; enable strict concurrency, sandbox and deliberate entitlements.
- [x] Add one composition root, repository interfaces, a test clock and mock system adapters.
- [ ] Configure formatting, package lockfile, basic macOS CI, diagnostic log privacy and a first versioned data schema.
  - Scaffold: formatting, workflow, private diagnostics and V1 schema implemented. There are no remote packages to lock; hosted CI has not run. See [the dependency inventory](../docs/DEPENDENCIES.md).
- [ ] Run signed sandboxed experiments for browser-domain access, permission denial/revocation and private-window detection. Record which integrations work under each proposed distribution channel before committing to one.
- [ ] Verify supported sleep, user-session and lock signals on target macOS versions; document any gaps in the proposed timer policy.

**Exit:** app launches, pure domain tests run, CI builds, local data survives relaunch, and permission/lifecycle experiments have recorded results. No production permissions are enabled merely by opening the app.

### Step 3 — Build the native shell and screen prototypes

- [x] Create Dashboard, Sound Library, Insights, History and Settings navigation.
- [x] Add menu bar scene, appearance preferences, onboarding and empty states.
- [ ] Use fixture data to review native sizing, accessibility and macOS 15/26/27 presentation.

**Exit:** all primary flows are navigable with keyboard and VoiceOver; native window behavior works; the supplied-reference feature matrix is covered by the redesigned screens.

### Step 4 — Implement timer domain and durable session ledger

- [ ] Implement phase/status reducer, duration validation, cycle rules, daily reset, manual breaks and extend/skip/end/reset.
- [ ] Store active segments, checkpoints, outcomes and idempotent phase completion.
- [ ] Handle sleep, wake, clock change, crash recovery and pause/resume.

**Exit:** fake-clock and integration tests cover all transitions, including rapid/repeated commands; paused and unobserved time is never credited.

### Step 5 — Add menu bar, shortcuts and launch controls

- [ ] Connect all surfaces to one coordinator; implement the four observed shortcut groups and conflict handling. Show Dashboard must not modify timing.
- [ ] Implement Dock visibility, login item, launch-hidden behavior and explicit Quit.
- [ ] Validate repeated launch, opening/closing windows and external shortcut conflicts.

**Exit:** timer operation works with the main window closed; no duplicated session state or orphaned controls.

### Step 6 — Prove the native audio engine

- [ ] Build a small original Focus recipe, procedural noise, one ambient recipe and a Fluid/Structured × Easy/Intense tuning pad, with a tested draft/Apply/Cancel policy.
- [ ] Implement native audio graph, asset manifest, sample preloading, voice limits, smooth gain/parameter changes and peak handling.
- [ ] Validate basic device switching, sample rates and offline operation; render controlled fixtures for audio analysis.

**Exit:** the user accepts extended listening quality and meaningful pad response; two-hour stability test passes. Do not expand 33 catalog entries before validating the sound foundation.

### Step 7 — Integrate sound with timer and context

- [ ] Add linked/independent audio policies, work/break recipe preferences, fades, mute, completion ducking and saved tuning.
- [ ] Add time-of-day control input, with manual preference precedence; optional weather adapter can follow.
- [ ] Add subtle visuals that stop consuming rendering work when hidden.

**Exit:** timer/audio interaction matrix in [plan Section 6](../outputs/IMPLEMENTATION_PLAN.md#6-timer-and-sound-integration) passes; audio failure cannot lose or falsely complete a focus session.

### Step 8 — Deliver statistics and history

- [ ] Implement tested range queries, day splitting, partial focus, completed blocks, streaks and sound attribution.
- [ ] Build Today hourly and 7-day/30-day/custom daily charts, live/partial totals, app percentages, 360-day history, empty states and coverage explanations.
- [ ] Implement versioned export/import and explicit delete-history; test schema migrations with real fixtures.

**Exit:** all screens reconcile to the same ledger; midnight, daylight-saving, clock-change and interrupted-session cases produce expected totals.

### Step 9 — Add completion experiences and customization

- [ ] Local notification authorization, one selected completion sound shared by focus/break phases, sound preview and consistent completion handling.
- [ ] Non-activating top-edge alert with actions; test notched/non-notched and multiple displays.
- [ ] Implement the eight observed menu-bar style names with timer text always visible, light/dark/system appearance and preference persistence. Resolve partly hidden style graphics through an explicit native design specification.

**Exit:** one completion action is counted once regardless of entry surface; no double sounds, keyboard-focus theft or stale notifications.

### Step 10 — Add Smart Nudge and habit reminders

- [ ] Implement local idle-age adapter and configurable suggestion rules.
- [ ] Add quiet hours, cooldown, dismissal and notification-denial behavior.
- [ ] Keep automatic pausing separately opt-in; document its effect on time accounting.

**Exit:** deterministic rule tests and daily-use review show useful prompts without repeated interruptions or lost reading time.

### Step 11 — Add local app attribution

- [ ] Record foreground slices only during active focus.
- [ ] Handle app changes, termination, session deactivation, pauses and unknown apps.
- [ ] Add opt-in, exclusion list, retention and app rankings.

**Exit:** attributed plus unattributed time reconciles to focus duration; disabling tracking stops collection immediately.

### Step 12 — Add browser domain adapters

- [ ] First run the permission/sandbox experiment in Step 2's environment; choose scripting or extension strategy before implementing the full list.
- [ ] Implement and test each supported adapter, normalization, private-mode policy, timeouts and revocation.
- [ ] Display adapter/permission coverage and browser-only fallback clearly.

**Exit:** published compatibility matrix with reproducible tests. Unreliable adapters remain explicitly unsupported; do not claim complete browser parity until audited reference coverage is met.

### Step 13 — Add Focus Style, share cards and data controls

- [ ] Define a small versioned heuristic from opted-in local data, with transparent criteria and insufficient-data handling.
- [ ] Create previewable cards with optional removal of app/domain names; export/share only on explicit user action.
- [ ] Validate full reset/export/import and local retention maintenance.

**Exit:** exported cards agree with statistics, sensitive details can be omitted, and no activity leaves the Mac implicitly.

### Step 14 — Complete the sound library and scenarios

- [ ] Author the remaining sound recipes/assets and mode-specific controls from the retained 33-entry catalog.
- [ ] Implement distinct timed scenario curves; integrate the existing timer engine rather than adding another competing clock.
- [ ] Validate noise spectra, separate-channel binaural behavior, spatial processing and the acoustic identity of each mode.
- [ ] Resolve artist content through licensing or explicitly original replacements; label deviations from reference.

**Exit:** each catalog row has an accepted audio recipe, controls, duration policy, rights record, automated checks and listening sign-off. No empty tiles masquerade as completed modes.

### Step 15 — Hardening and first complete desktop release

- [ ] Perform accessibility, migration, recovery, memory, battery, CPU and multi-display testing.
- [ ] Run two-hour focus and eight-hour audio tests; exercise device changes, sleep/wake and rapid mode switching.
- [ ] Validate no microphone/screen content access in core use and no undeclared data transmission.

**Exit:** all local desktop feature rows and Step 18 authentication have acceptance evidence. This milestone can precede optional sync and commerce, but those remain tracked rather than silently dropped.

### Step 16 — Optional multi-Mac sync capability

- [ ] Start from the observed Sync timer setting; specify and test pairing, ownership and history sync separately. Authentication now uses Supabase (Step 18). Decide whether approved sync uses Supabase/Postgres under the same identity or private CloudKit under a separate iCloud identity; record the choice and ownership implications before implementing sync. No sync backend is selected by adding authentication.
- [ ] Sync settings, timer state and approved history only. Keep app/domain detail local.
- [ ] Define a single active timer owner, revision/device IDs, conflict rules, retries, deletion tombstones and offline merge behavior. A remote timer is read-only until explicit takeover.
- [ ] Use notifications as hints and fetch authoritative state; never use cloud delivery latency as the countdown clock.

**Exit:** two-Mac tests pass for offline recovery, takeover, conflict, duplicate delivery, deletion and sign-out. Mobile support remains outside scope. Keep the selected cloud adapter outside the pure timer domain.

### Step 17 — Distribution and optional purchase parity

- [ ] Choose Mac App Store or direct distribution after the browser-adapter sandbox spike.
- [ ] For App Store commerce, use StoreKit 2 with verified lifetime entitlement, restore, offline behavior and revocation tests. If commerce is not wanted, record that deliberate difference and expose all capabilities.
- [ ] Prepare signing, assets, licenses, privacy description, crash diagnostics policy and release notes.
- [ ] Create a signed/notarized build for direct distribution, or a validated App Store archive as appropriate. Test a clean-machine install, upgrade and data preservation.

**Exit:** a reviewable release artifact and release checklist. Actual publication is a separate action. App Store distribution requires sandboxing; direct distribution requires the appropriate signing/hardened-runtime/notarization workflow. [Apple distribution preparation](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution), [Developer ID and notarization](https://developer.apple.com/developer-id/)

### Step 18 — Apple, Google and email authentication with Supabase

**Order:** begin after Steps 2/3 establish boundaries and screens; finish before Step 15 release hardening and Step 16 cloud sync. Authentication is required scope; sync remains a separate capability. [Architecture and setup](../docs/AUTHENTICATION.md).

- [ ] Resolve the decisions and external setup above. Record them in the authentication ADR and configuration checklist; pause dependent work when an input is missing.
- [ ] Pin and audit the official Supabase Swift SDK through SPM; update dependency/license inventory and lockfile. Add an injectable AuthRepository and isolated Supabase adapter, with deterministic mock tests; keep network authentication outside FocusDomain and audio rendering.
- [ ] Implement typed public configuration and native build/runtime loading, debug/release validation, network entitlements as needed, and environment-specific callback registration/allowlists. Native Swift does not automatically load `.env` files.
- [ ] Build accessible SwiftUI login/signup, provider buttons, progress/cancellation, error/retry, verification/recovery and account/settings screens; enforce the selected sign-in policy consistently across window/menu bar entry points.
- [ ] Implement native Sign in with Apple using AuthenticationServices, cryptographically random nonce and hashed nonce request, and Supabase ID-token exchange. Handle cancellation, credential revocation, private relay and first-sign-in name capture without overwriting it on later sign-ins.
- [ ] Implement Google OAuth using ASWebAuthenticationSession and Supabase PKCE; distinguish Google's Supabase callback from the app callback, validate the allowed URL components, handle cancellation and duplicate/stale callbacks, and complete the SDK session exchange exactly once.
- [ ] Implement the selected email signup/login flow. For passwords include confirmation/resend, reset/recovery and password update; for passwordless include OTP or magic-link verification/resend. Test malformed, expired, reused and cross-device links/codes according to the selected flow.
- [ ] Implement Keychain-backed session storage using the pinned SDK's supported adapter; observe auth state, restore/refresh sessions, handle expiry/offline/revocation, and sign out without leaking tokens or exposing a previous user's data.
- [ ] Implement and migrate account-scoped local ownership using the stable Supabase user UUID. Test two users, account switching, sign-out, deletion and active-timer handling; implement guest-history adoption only if local unsigned use is approved.
- [ ] If remote profile or user data tables are needed, commit SQL migrations, least-privilege grants and `auth.uid()` ownership RLS policies; test unauthenticated access and cross-user read/write denial. Authentication alone does not authorize uploading activity/history.
- [ ] Implement explicit account deletion through a protected server endpoint that verifies the caller and deletes only their own account/data; handle local removal, identity unlinking where supported, and required Apple token revocation. Privileged credentials belong only on the server.
- [ ] Define and test supported identity linking/reauthentication; handle Apple relay and provider email differences without merging accounts based on email alone. Never describe automatic linking as guaranteed.
- [ ] Run real Apple/Google/email integration tests on a correctly signed Mac build plus mock/UI tests for cancellation, invalid credentials, verification, recovery, relaunch, offline expiry, account switching, deletion and callback abuse. Record provider/email delivery evidence and update Graphify before marking any implementation item complete.

**Exit:** all three sign-in methods and the selected email signup/verification/recovery flow work in a signed macOS app; session storage and account isolation pass tests; callback/provider/SMTP configuration is documented; no privileged keys or user tokens are committed; account deletion is verified. Authentication does not introduce a second timer or implicitly enable cloud sync.

