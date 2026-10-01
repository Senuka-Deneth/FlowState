# Endel web app: requirements analysis and feasibility study

> Scope update, 1 October 2026: the requested product is now a native Mac app combining focus audio, Kofe Flow-style timers, and statistics. Use [the native implementation plan](IMPLEMENTATION_PLAN.md) for the current architecture and delivery steps. This earlier study remains the provisional Endel catalog and research record.

> Later supplied-reference review: the Endel **mobile Focus** recording establishes Fluid → Structured horizontally, Easy → Intense vertically, and an Apply button. Read [REFERENCE_ANALYSIS.md](REFERENCE_ANALYSIS.md) for timestamps, evidence and limits. Statements below about unverified pad labels describe the earlier research state; exact DSP mappings, other modes and current web behavior remain unverified.

Prepared 1 October 2026. Scope: browser application only, with a redesigned interface. Research and requirements only; no application implementation or audio prototype has been built.

## 1. Decision

**A browser app with comparable adaptive sound generation and controls is technically feasible. Exact Endel audio and complete feature parity are not established by this research.**

The best development direction is an independently implemented sound engine using original or appropriately licensed sound material. The engine should combine procedural audio, curated samples, constrained musical variation, gradual parameter changes, and timed session logic. Audio quality is the principal product challenge; recreating the screen layout is much easier.

Your hypothesis is partly supported: stored sound elements are involved. However, the public evidence also describes synthesis, sequencing, contextual rules, and multi-layer composition. The pad appears to influence which sounds participate, as well as sound character. Treating it as a volume mixer for a handful of static loops would be an inadequate starting specification.

There are three different success criteria:

| Target | Assessment | What it requires |
| --- | --- | --- |
| Similar user functionality with a new UI | Feasible, subject to a live web feature audit | Independent implementation and a verified behavior inventory |
| Similar sonic character and listening quality | Feasible in principle; needs an audio prototype and listening trials | A skilled sound designer, suitable assets, and repeated tuning |
| Identical sound output and proprietary engine behavior | Not established; cannot be promised from public documentation | Exact assets, engine rules and parameters, and permission or licensing where applicable |

Recommendation: proceed with an audio feasibility prototype before a full product build. Keep the complete catalog as the intended eventual scope; use a small initial set to validate quality and performance.

## 2. Evidence and limits

Evidence labels used throughout:

- **Web listing:** text retrieved from the public web app; establishes listed names, not successful playback or interaction behavior.
- **Documented:** a claim in Endel's official pages, publisher release notes, or a statement by an identified Endel representative.
- **Patent disclosure:** describes possible methods, not proof that a specific method is deployed in the current web app.
- **Proposed:** our implementation or acceptance target, not a discovered Endel setting.
- **Unknown:** needs direct observation, measurement, source access, or licensing information.

The public player text was retrieved before attempting interactive inspection. That browser access request was declined. No live playback, drag test, signed-in session, network inspection, asset inventory, waveform recording, or performance measurement was completed. Research then continued using public documentation rather than another route into the blocked player.

Consequently, this is a **preliminary requirements baseline and desk feasibility study**, not a completed reverse-engineering report. In particular, exact pad axis orientation, per-mode pad availability, premium behavior, browser offline support, and exact sound material remain unverified.

Public documents describe several platforms. Mobile or Mac features must not automatically become claims about the web app. There are also catalog differences between the marketing site and web listing.

## 3. What the sound engine does

### 3.1 Supported findings

Endel describes Pacific as an on-device engine that maps listener context to pre-designed soundscape logic and elements. Depending on platform and permissions, inputs may include time, weather, bedtime, natural light, motion, heart rate, and head position. These are product-family capabilities; the current web input subset is unknown. [Endel technology](https://endel.io/technology)

Its support material describes a system of sound layers, modulation, and effects combined according to listener state. It distinguishes adaptive app output from static streaming releases. [Endel FAQ](https://endel.zendesk.com/hc/en-us/sections/360001187800-FAQ)

The automatic-composition patent describes note sequences, single-note recordings, sample libraries, rule-controlled layer selection, and a real-time mixer. It also describes arranging sections into phases and phases into longer soundscapes. This is evidence for a hybrid composition approach, not a recovered implementation. [US12248289B2, description and Figures 4–14](https://patents.google.com/patent/US12248289B2/en)

An identified Endel community lead described an in-house synthesizer added to Focus and said the X–Y tuning pad makes some sounds available only in certain positions. This is historical evidence from the Focus Tune launch, not a measurement of today's web app. [Endel maker discussion](https://www.producthunt.com/p/endel/endel-focus-tune)

### 3.2 Engineering interpretation

The evidence supports the following broad model:

```text
Selected mode + context + manual preference + session phase
                         ↓
                Soundscape control rules
                         ↓
     Sample selection / note sequencing / synthesis / variation
                         ↓
                Layer mixing and effects
                         ↓
                 Continuous audio output
```

The diagram is an interpretation, not Endel's recovered audio graph. It does not establish whether the web implementation uses JavaScript, WebAssembly, a particular audio framework, neural inference, or a combination.

The main advantage over a recording is the ability to change composition and parameters while listening. Whether that explains your personal preference over YouTube requires listening comparisons. A generated stream can still reuse motifs and samples; “endless” does not guarantee that every moment is unique.

A practical equivalent does not initially require a large music-generation model or cloud GPU service. A carefully designed rules engine can deliver the relevant interaction: continuous evolving sound that responds to controls and context. Any machine learning should earn its place through measurable benefit.

## 4. The adjusting pad

### 4.1 What is known

The historical maker statement explicitly identifies an **X–Y pad** and position-dependent sound availability. That implies more than adjusting one global volume. The exact relationship between position and individual layers is not disclosed. [Endel maker discussion](https://www.producthunt.com/p/endel/endel-focus-tune)

Publisher Mac release notes describe sound tuning in Focus, Relax, Sleep, Hibernation, Nature Elements, and Dynamic, with Dynamic identified as the renamed Focus Tune. This establishes historical Mac functionality only; it does not settle the web control matrix. [Publisher release history, Mac listing](https://apps.apple.com/ru/app/endel-%D0%B7%D0%B2%D1%83%D0%BA%D0%B8-%D0%B4%D0%BB%D1%8F-%D1%81%D0%BD%D0%B0-%D0%B8-%D0%BE%D1%82%D0%B4%D1%8B%D1%85%D0%B0/id1346247457?platform=mac)

### 4.2 What is not known

| Question | Current status |
| --- | --- |
| Exact labels and their placement on today's web pad | Unknown |
| Which modes expose a pad, sliders, selectors, or no tuning | Unknown on web |
| Whether regions crossfade stems, alter synthesis, change note probability, or combine these | Position-dependent sound selection documented; detailed method unknown |
| Tempo, filter, reverb, modulation, or gain ranges | Unknown |
| Continuous movement versus discrete internal regions | Unknown |
| Whether tempo changes affect pitch | Unknown |
| Transition delay, smoothing curve, and phrase-boundary behavior | Unknown |
| Relationship between manual tuning and automatic adaptation | Unknown |
| Defaults, reset, paused edits, and persistence across sessions | Unknown |

### 4.3 Proposed independent control design

Use two understandable perceptual controls, initially **energy** and **texture**. Label and orient the redesigned pad after the reference audit and listening tests. Do not assert that these are Endel's exact axes.

| Control direction | Proposed audible result | Candidate engine parameters |
| --- | --- | --- |
| Lower → higher energy | More active rhythm and denser events | Note probability, rhythmic pattern, percussion mix, modest tempo range |
| Softer → clearer texture | Less diffuse, more articulated sound | Filter cutoff, envelope attack, high-frequency balance, effect mix |
| Particular regions | Additional timbres or motifs become eligible | Sample eligibility, instrument choices, weighted pattern selection |

Normalize pad position to two values in `[0,1]`. Each mode owns its mapping. A generic mapping must not make all modes sound like the same composition.

Use parameter ramps to avoid clicks and abrupt timbre changes. Change musical patterns at suitable phrase boundaries. Permit an immediate tonal response while slower composition changes develop. Do not use simple playback-rate changes on a complete mixed loop to stand in for independent tempo control, because that also changes pitch.

For a prototype, test 100–500 ms continuous parameter ramps and 2–8 second crossfades for large changes. These are starting experiments, not reference values. Crossfade curves must be tested with correlated material; a fixed equal-power fade is not automatically appropriate for every pair of layers.

Manual preference should remain stable while context makes gentle changes around it. This precedence rule is a proposed design decision; reference behavior must be checked.

Provide keyboard control and two labeled slider alternatives. Save per-mode positions and provide reset. These are redesign requirements, subject to the final parity specification.

## 5. Catalog and audio requirements

The retrieved web listing contains **33 distinct entries: 16 soundscapes and 17 scenarios**, grouped below. Names establish catalog presence only; all entries still require playback and control verification. [Public web listing](https://app.endel.io/)

**No exact asset, waveform, stem, oscillator patch, tempo range, key, or effect preset was identified for any mode.** Every audio recipe in the following tables is proposed original content. None is a transcription of Endel's underlying assets.

### 5.1 Soundscapes: 16 entries

| Web group | Reference mode | Proposed original audio direction | Outstanding reference check |
| --- | --- | --- | --- |
| Focus | Focus | Gentle rhythmic layers, warm harmonic bed, restrained note variation | Tuning, adaptation, characteristic rhythmic behavior |
| Focus | Colored Noises | Procedural noise bank with spectral shaping and smooth selection | Exact nine labels, spectra, selectors, and control mapping |
| Focus | Dynamic Focus | Region-dependent synthesis and sample layers with energy/texture control | Pad axes, regions, transition and persistence rules |
| Focus | Study | Restrained beat patterns and soft harmonic motifs | Rhythm palette, tuning options, variation rate |
| Focus | Deeper Focus | Original sparse electronic percussion and low harmonic movement | Artist material; equivalent needs original content or a license |
| Relax | Relax | Slowly changing sustained tones and minimal musical events | Tuning, automatic changes, layer palette |
| Relax | 8D Odyssey | Original moving stereo textures and spatial trajectories | Actual web spatial renderer and controls |
| Relax | Nature Elements | Original field recordings and gentle ambient layers | Available elements, mixing controls, loop transitions |
| Relax | Spatial Orbit | Original spatial sound sources with controlled movement | Stereo vs binaural processing, trajectories, head tracking |
| Relax | Hibernation | Warm, low-density textures with subdued high frequencies | Region behavior, acoustic palette |
| Relax | Recovery | Stable, sparse ambient sound with smooth evolution | What distinguishes its recipe and timeline |
| Relax | Wiggly Wisdom | Original licensed narration integrated with an ambient bed | Spoken-word rights, clip scheduling, voice controls |
| Sleep | Sleep | Continuous masking texture and very slow tonal evolution | Modulation and phase logic, tuning availability |
| Sleep | Rainy Outside | Original rain recordings layered with a quiet harmonic bed | Rain controls, ambience variants, transitions |
| Sleep | Wind Down | Original evening ambient material with gradual simplification | Artist assets, bedtime transitions, phase behavior |
| Sleep | AI Lullaby | Original lullaby textures and optionally licensed gentle vocals | Artist assets, voice layers, phase behavior |

Endel's public descriptions identify rain material, laid-back beats for Study, nature sound, immersive spatial experiences, and artist audio or spoken-word collaborations. These inform the broad directions, not the proposed recipes' exact implementation. [Endel soundscape descriptions](https://endel.io/soundscapes)

The marketing site advertises nine noise colors, but the exact bank and its spectral definitions were not recovered. Implementing nine arbitrarily named filters would not establish parity. “8D” and “spatial” also do not establish that the web version performs head-tracked rendering. [Endel soundscape catalog](https://endel.io/soundscapes)

### 5.2 Scenarios: 17 entries

Each proposed recipe needs its own opening, middle, and ending behavior, expressed as a function of the chosen duration. Reusing a bed may be appropriate, but changing only the title and countdown would not reproduce a distinct scenario.

| Reference scenario | Proposed original content and session behavior | Key unanswered question |
| --- | --- | --- |
| Focus Timer | Alternate selected work and rest recipes with phase crossfades | Web work/rest options, task field, cycles, long breaks, auto-advance |
| Anxiety Relief | Quiet ambient bed, low event density, gradual easing | Exact phase progression and controls |
| Arousal | Warm slow pulses and restrained texture changes | Distinct content and progression |
| Attention Boost | Short rhythmic activation followed by steady material | Duration choices and defining sound features |
| ASMR | Licensed or original close-mic textures, scheduled gently | Trigger library, spatial processing, tuning |
| Baby Sleep | Original stable low-variation material | Reference duration and finishing behavior |
| Binaural Beats | Separate left/right carriers integrated into a timed bed | Carrier frequencies, envelope, sweep and stereo controls |
| Brain Massage | Slow modulation and spatial textures | Which modulation and movement create the reference effect |
| Chores | Original steady rhythmic material | How it differs from other task recipes |
| Create | Original low-density patterns with wider harmonic variation | Reference musical constraints |
| Deep Work | Restrained rhythmic bed sustained through a long middle phase | Intro/end structure and intensity |
| Self Care | Quiet sustained tones and nature textures | Distinct recipe and phase transitions |
| Read | Low-distraction ambient sound with sparse events | Speech, melody, and rhythmic density |
| Power Nap | Settling phase, quiet middle, distinct completion phase | Whether completion fades out or includes a wake-up cue |
| Meditate | Original slow ambience and restrained spatial movement | Timer, ending cue, modulation |
| Wake Up | Gradually brighter and more active original material | Session vs scheduled alarm behavior on web |
| Tinnitus Relief | Adjustable original masking texture after reference validation | Fixed tone, bandwidth, options, finishing behavior |

Endel documents phased timed sessions, describes its Binaural Beats scenario as using a 40 Hz difference, and lists a 4500 Hz tone for Tinnitus Relief. It says other sounds do not use binaural beats. A 40 Hz difference does not reveal the two carriers; a 4500 Hz label does not reveal a full waveform or masking filter. [Endel scenario descriptions and FAQ](https://endel.io/scenarios)

Focus Timer is described as a Pomodoro-style tool with work/rest intervals and a task headline. These are documented product features, but the current web configuration options remain untested. [Endel Focus page](https://endel.io/focus)

### 5.3 Catalog boundary

Move, Miguel's Clarity Trip, and Solfeggio Tones appear in broader Endel materials but were absent from the retrieved web listing. Keep them outside this baseline unless a later signed-in web audit finds them. The marketing scenario list also includes Quick Task, whereas the retrieved web list includes Attention Boost. Do not silently substitute one for the other. [Soundscape catalog](https://endel.io/soundscapes), [Scenario catalog](https://endel.io/scenarios)

## 6. What “exact sound waves” would require

A rendered waveform depends on source material, timing, random choices, layer gain, effects, and context. A single recording is an output example, not the complete engine specification. In a generative product, two valid sessions may differ.

To specify exact sonic reproduction, each mode would need:

1. Complete source files or synthesis patches, including versions and permitted usage.
2. Sample start/end and loop boundaries, tuning, gain, and channel layout.
3. Sequencing rules, musical constraints, event probabilities, and random-state handling.
4. Pad mapping, layer eligibility, envelopes, filter and effect parameters.
5. Context mapping, defaults, update cadence, and precedence over manual settings.
6. Session phase rules, transition curves, and output processing.

The current research recovered none of these complete mode specifications. Publicly disclosed concert pitch of 440 Hz is a tuning reference, not a statement that every sound is a 440 Hz sine wave. [Endel FAQ](https://endel.io/soundscapes)

Listening and spectral analysis can characterize output and constrain candidate designs. They cannot uniquely recover a layered synthesis graph. Hearing a bell-like sound, for example, does not establish whether it comes from a sample, additive synthesis, or another technique.

For equivalent quality, commission an original asset library and store a manifest for each item: source, license, checksum, duration, channels, sample rate, key if applicable, loudness, loop boundaries, role, and allowed modulation. Keep reusable materials separately from mode-specific compositions.

Procedural noise and basic tones need little recorded material. Nature, ASMR, narration, and artist-like compositions need substantially more sound production. Existing artist modes have a separate content dependency: reproducing Grimes, James Blake, Richie Hawtin, or Alan Watts material requires resolving the relevant rights. Original replacement content would provide analogous functionality, not identical branded content.

## 7. Functional requirements baseline

“Required” below means required for the proposed clone. It does not imply that every detail has been observed in Endel. **Audit** marks behavior whose reference details must be settled.

| ID | Requirement | Evidence / status | Completion condition |
| --- | --- | --- | --- |
| F01 | Explore the complete baseline catalog by group | Web listing | Every baseline entry has a distinct mode or scenario definition |
| F02 | Start, pause, resume and display the active item | Public player shows paused state; full behavior audit | Sound and UI agree across transitions and loading |
| F03 | Generate continuously evolving soundscapes | Documented across product; web internals unknown | Supported long sessions continue without full-track restarts |
| F04 | Switch modes with smooth audio transitions | Proposed quality requirement; audit reference behavior | No abrupt peak or broken playback on rapid switches |
| F05 | Provide master volume and mute behavior | Required; audit | Controls change audio predictably and persist as specified |
| F06 | Provide the correct per-mode tuning controls | Tuning documented on other platforms; web audit | Each control has an approved audible mapping |
| F07 | Preserve defaults and reset tuning | Required; audit | Reset restores versioned defaults; persistence is explicit |
| F08 | Adapt audio to the available context inputs | Documented product capability; web subset audit | Context changes affect only intended parameters, with fallback |
| F09 | Run scenarios with a chosen duration and phase logic | Documented product capability; duration UI audit | Opening/middle/ending occur at approved points |
| F10 | Configure and run Focus Timer | Documented product capability; web audit | Approved work/rest cycles, editing and completion rules work |
| F11 | Define timer behavior while paused or interrupted | Unknown | One explicit policy applies to sound, countdown and history |
| F12 | Show mode-linked generative visuals | Documented web capability | Visuals reflect the active state and respect reduced motion |
| F13 | Continue playback in background tabs where supported | Required; reference audit | Browser/device test matrix documents working conditions |
| F14 | Save preferences locally | Proposed baseline | Reload restores settings without unsolicited playback |
| F15 | Sign in/out and reflect access level | Sign In and FREEMIUM in web listing; details audit | Account state and catalog entitlement stay consistent |
| F16 | Handle restricted content and session limits | Premium documented elsewhere; web rules unknown | Verified web entitlement matrix drives access behavior |
| F17 | Show loading, unsupported-format and playback errors | Proposed robustness requirement | Actionable recovery without an unintended volume jump |
| F18 | Manage context permission and denied-input fallback | Required | Core audio works without optional location or weather data |
| F19 | Prevent accidental duplicate-tab playback | Proposed product requirement; audit | Explicit takeover or approved simultaneous-play policy |
| F20 | Support OS media controls when available | Proposed enhancement; audit | Capability-tested controls agree with application state |
| F21 | Provide support, account and preference flows | Candidate web scope; audit | Every observed web flow has an approved equivalent |
| F22 | Implement cache/offline behavior | Candidate requirement; web support unverified | Download state and uncached-mode errors are explicit |

Additional candidates need verification before entering mandatory scope: favorites, presets beyond tuning persistence, usage history or weekly insights, circadian guide, automatic mode selection, scheduled alarms, notifications, subscription purchase/cancellation, localization, and device-output selection.

Native app blocking, Apple Health access, watch integration, AirPlay-specific UI, mobile exercise features, and native app-store purchase restoration are outside this web-only baseline. Do not add them solely because they exist in mobile marketing.

A standalone public product may need its own authentication and billing. A personal-use implementation could omit paid access mechanics by an explicit scope decision. Neither decision should be silently assumed to represent full web parity.

## 8. Redesigned UI requirements

The redesigned interface should preserve discoverability and control over sound while giving the pad a clearer explanation.

- A quiet player area with the active mode, play/pause, volume, tuning, and timer accessible together.
- A catalog that separates endless listening from timed sessions.
- Clear pad labels, a visible current position, reset, and accessible slider alternatives.
- A compact explanation of each control's audible effect, rather than synthesis terminology.
- Explicit work/rest phase and remaining time during interval sessions.
- Optional context details showing whether adaptation uses local time, manual location, or available weather.
- Motion that can be reduced or disabled independently of playback.
- Responsive desktop and tablet layouts, keyboard operation, visible focus, and sufficient contrast.

Favorites and saved named presets could improve the redesign, but should be recorded as additions unless found in the reference. A visual mockup is not part of this analysis phase.

## 9. Proposed browser architecture

### 9.1 Audio and application boundaries

Use TypeScript for explicit mode definitions and control mappings. Choose the UI framework based on the eventual project's conventions; it is not the main feasibility constraint.

Use Web Audio for mixing, oscillators, sample playback, gain ramps, filtering, and effects. Use AudioWorklet where custom noise or DSP is required: it runs audio processing in a separate audio thread and requires a secure context. These are platform capabilities, not evidence of Endel's stack. [Web Audio specification](https://www.w3.org/TR/webaudio/), [AudioWorklet documentation](https://developer.mozilla.org/en-US/docs/Web/API/AudioWorklet)

```text
Redesigned UI ──→ Playback/session controller
                         │
Context adapter ──→ Independent control mapping
                         │
Mode definitions ──→ Composer / audio-clock scheduler
                         │
Original assets ──→ Sources → layer processing → mix → output
                         │
                    Visual state
```

The UI must not control precise musical timing through animation frames. Schedule audio against the audio clock. Use a tested look-ahead scheduling strategy or an audio-thread event scheduler where needed; test background throttling before choosing. Use wall-clock deadlines plus accumulated pause state for long timer displays, and synchronize audio transitions to the appropriate clock. Define behavior after device sleep explicitly.

Separate controls from rendering. Changing a mode or dragging the pad should update parameters rather than rebuild the entire audio context. Limit active voices and effect cost. Preload only necessary assets and release buffers after transitions finish.

### 9.2 Data and backend

Suggested entities:

| Entity | Purpose |
| --- | --- |
| ModeDefinition | Category, layer roles, mapping, variation rules, versions |
| AudioAsset | Source file or patch, metadata, loop information, rights record |
| ScenarioDefinition | Duration constraints, phase curve, completion policy |
| UserPreference | Volume, per-mode tuning, timer settings, consent |
| SessionState | Active mode, playback state, elapsed time, phase, random seed |
| Entitlement | Access rules, if accounts or payment are in scope |

Use local storage or IndexedDB for settings and asset metadata. An optional backend can manage accounts, preferences, entitlement and asset manifests. Deliver owned audio from object storage/CDN. Browser synthesis avoids continuous personalized audio streaming costs, although sample downloads still consume bandwidth.

Weather should be optional, obtained through an approved provider and cached. Local time and an explicitly supplied city can provide useful context without precise geolocation. No new app should depend on private Endel endpoints.

Offline asset caching can use service workers, but cached access is subject to browser storage and eviction. Validate the exact behavior rather than inheriting native app offline promises. [Service Worker documentation](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)

### 9.3 Browser constraints

Sound generally needs a user gesture to start or resume under autoplay policies. Design a reliable explicit Play action. [Autoplay documentation](https://developer.mozilla.org/en-US/docs/Web/Media/Guides/Autoplay)

Hidden pages may be throttled, frozen, or discarded; audible playback affects browser decisions but does not guarantee uninterrupted operation under resource pressure or system sleep. A browser tab must not be promised as a dependable closed-laptop alarm. [Chrome page lifecycle documentation](https://developer.chrome.com/docs/web-platform/page-lifecycle-api)

Media Session integration is useful for supported OS/browser media controls, but must be capability-tested with the actual playback implementation. [Media Session documentation](https://developer.mozilla.org/en-US/docs/Web/API/Media_Session_API)

Heart rate, native health history, walking cadence, and head tracking are not automatic desktop browser inputs. Any later wearable or sensor integration needs a separate supported interface and requirement. Browser-only adaptation should degrade gracefully to time and explicit preference.

## 10. Nonfunctional targets and verification

These are **proposed release targets**, not measured Endel performance. Confirm target machines, browsers, network conditions, and test fixtures during the prototype.

| Area | Initial target | Verification |
| --- | --- | --- |
| Pad response | Audible continuous-parameter response within 150 ms on the target device, before deliberate smoothing | Timestamped input/output measurements |
| Playback start | Cached mode audible within 1 second of an accepted Play gesture | Repeated warm-start tests; record cold-load separately |
| Continuity | No audible clicks or dropouts in supported 2-hour focus and 8-hour sleep runs | Captured output and listening, including hidden-tab tests |
| Peak control | Initial output target no higher than −1 dBTP, verified across transitions | True-peak analysis; runtime gain budgeting and peak handling |
| Loudness consistency | No unintended loudness step when changing modes or pad position | Measure and listen across a pad grid and mode pairs |
| Memory | Working audio buffer target below 250 MB for a normal session | Profiling and repeated mode-switch tests |
| UI accessibility | Complete playback/tuning/timer operation by keyboard and assistive technology | Task-based accessibility review |
| Failure recovery | Retain chosen mode/settings and require an explicit restart after unrecoverable interruption | Offline, rejected permission, failed asset and context-resume tests |
| Privacy | Optional context; minimize retained location information | Data-flow review and denied-permission tests |

For sizing: uncompressed stereo float32 audio at 48 kHz occupies about 23 MB per minute: `48,000 × 60 × 2 × 4` bytes. Ten one-minute decoded stems are approximately 230 MB, before other app memory. This calculation is a design example, not an Endel asset-size measurement. Stream longer materials where appropriate and cache short reusable elements deliberately.

A peak limit controls digital output, not sound pressure at the ear. Do not derive a hearing-safe volume claim from it.

Audio acceptance needs both objective checks and listening. Test repetition, fatigue, distracting transitions, timbre quality, and usefulness over 20–60 minute sessions. Start with the user's preferred Focus experience, then expand. Similar controls or spectra do not establish comparable cognitive effects. Endel's published research cannot validate a newly implemented engine automatically. [Endel science and research references](https://endel.io/science)

## 11. Reference audit still required

If interactive access is later available, complete an audit before freezing the full parity specification. Use ordinary permitted sessions; no purchase, account creation, or protected asset extraction is assumed by this report.

| Audit | Method | Deliverable |
| --- | --- | --- |
| Catalog/access | Compare available guest and legitimately accessible signed-in states | Mode list, access rules, session limits |
| Controls | Inspect every mode and scenario | Per-item control matrix and defaults |
| Pad behavior | Visit a 5×5 position grid; sweep each axis; return to the same coordinates | Labels, region behavior, delays, reproducibility, saved-state rules |
| Context behavior | Change only available inputs through normal controls | Input availability, fallback and precedence matrix |
| Timer/session behavior | Test start, pause, edit, finish, reload and backgrounding | State transition specification |
| Sonic characterization | Where recording is permitted, compare output at fixed context and positions | Spectrum, onset density, modulation, loudness and stereo observations |
| Browser behavior | Test supported browsers, hidden tabs, interrupted audio, offline and device sleep | Compatibility and recovery matrix |
| Network architecture | If permitted, observe request types and timing during normal playback | Evidence for sample loading vs continuous streams; no assumed internal stack |

A pad grid should hold other inputs constant and repeat trials. Generative randomness can otherwise make a layer change look like a pad effect. Include an unchanged-position control sample for every series.

Even this audit would characterize behavior rather than recover exact source files or prove an internal algorithm. Freeze a versioned reference date and keep a discrepancy register as Endel changes.

## 12. Feasibility, dependencies and effort

| Work area | Feasibility | Principal dependency |
| --- | --- | --- |
| New UI, player and catalog | High | Final web behavior matrix |
| Responsive pad and smooth mixing | High | Mapping design and audio testing |
| Endless original ambient generation | High | Sound designer and sufficient controlled variation |
| Similar perceived Focus quality | Unproven until prototype | User listening acceptance |
| Timed scenarios and interval workflow | High | Phase definitions and reference timer rules |
| Time/weather adaptation | High for a limited browser model | Context policy and data provider |
| Stereo/spatial sound | Feasible | Reference characterization and processing choice |
| Full sensor equivalence | Limited on browser | External supported integrations |
| Exact artist mode content | Dependent on rights and access | Content agreements |
| Complete web parity | Currently unverified | Interactive audit |

The relevant automatic-composition patent publication is a granted US patent, with grant publication dated 11 March 2025. Its claims are a material commercial feasibility dependency. Original assets and independently written code do not, by themselves, establish freedom to operate. A commercial implementation needs jurisdiction-specific patent and content review; this report has not performed claim mapping or issued a clearance conclusion. [US12248289B2](https://patents.google.com/patent/US12248289B2/en)

### Planning estimates

These are engineering judgment ranges, not vendor quotes. Assumption: two experienced engineers, one sound designer working substantially on audio production, and part-time product design/QA. Ranges depend heavily on reference access, sound quality expectations, and content rights.

| Milestone | Indicative time from start | Result |
| --- | --- | --- |
| Audio feasibility prototype | 1–2 weeks | Original Focus-like material, one pad, uninterrupted playback and initial listening review |
| Useful first release | 6–10 weeks total | Redesigned player, roughly 4–6 original modes, pad, volume, scenario timer, interval workflow and browser checks |
| Broad original catalog | 12–24 weeks total | All 33 baseline entries with distinct approved recipes and production hardening |
| Exact branded audio/catalog | No responsible estimate yet | Requires rights, assets and possibly technology licensing first |

A 4–6 mode release is an intermediate milestone, not completion of your requested full clone. Licensing negotiation, unavailable assets, deeper spatial processing, payment requirements, or a larger audited feature set can extend these estimates.

Main cost drivers are engineering time, sound production, listening and compatibility QA, content licensing, and any necessary patent review or technology agreement. Ongoing costs include hosting, sample storage/bandwidth, optional weather, and account services. There is no defensible monetary estimate until rates, audience, deployment geography, traffic, and licensing are known.

## 13. Recommended next decision

Approve the product direction only conditionally: a revamped browser interface with comparable functionality, developed around original or licensed sound material. Keep exact Endel audio as a separate unresolved dependency.

Before authorizing a full build, resolve three gates:

1. **Behavior gate:** finish the live web audit and approve the control/access/session matrix.
2. **Audio gate:** accept a Focus-oriented original prototype after extended listening and pad tests.
3. **Content/commercial gate:** choose original replacements or obtain the needed content/technology rights, with patent review if launching commercially.

This phase supplies a usable requirements baseline and a feasible implementation route. It does **not** identify exact sound waves for every mode, verify the live web pad mappings, or establish all account-dependent functionality. Those remain explicit research and production tasks rather than assumed findings.
