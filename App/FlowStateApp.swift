import AppKit
import FocusAudio
import FocusDomain
import FocusPersistence
import MacIntegration
import SwiftUI

@main
struct FlowStateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var model: AppModel
    @State private var preferences: Preferences

    init() {
        let testing = ProcessInfo.processInfo.arguments.contains("--ui-testing")
        let testRun = ProcessInfo.processInfo.environment["FLOWSTATE_TEST_RUN_ID"]
            .flatMap(UUID.init(uuidString:))
        let testStoreURL =
            testing
            ? testRun.map {
                FileManager.default.temporaryDirectory
                    .appendingPathComponent("FlowStateUITests-\($0.uuidString)")
                    .appendingPathComponent("Focus.store")
            } : nil
        let defaults: UserDefaults
        if testing {
            let suite = "dev.flowstate.scaffold.uitests.\(testRun?.uuidString ?? "ephemeral")"
            defaults = UserDefaults(suiteName: suite)!
            if testRun == nil { defaults.removePersistentDomain(forName: suite) }
        } else {
            defaults = .standard
        }
        _preferences = State(initialValue: Preferences(defaults: defaults))
        _model = State(
            initialValue: AppModel(
                repositoryFactory: {
                    try SwiftDataFocusRepository.open(at: testStoreURL, inMemory: testing)
                },
                clock: SystemTimeSource(), audio: UnavailableAudioController(),
                lifecycle: WorkspaceLifecycleObserver()
            ))
    }

    var body: some Scene {
        Window("FlowState", id: "dashboard") {
            ShellView(model: model, preferences: preferences)
                .preferredColorScheme(preferences.appearance.colorScheme)
                .task { await model.start() }
        }
        .defaultSize(width: 960, height: 680)
        .commands {
            CommandGroup(replacing: .help) {
                Button("FlowState Help") { appDelegate.showHelp() }
            }
        }

        MenuBarExtra {
            MenuBarView(model: model)
        } label: {
            Label {
                Text("50:00").monospacedDigit()
            } icon: {
                Image(systemName: "timer")
            }
            .accessibilityLabel("FlowState, ready, 50 minutes")
        }

        Settings {
            SettingsView(preferences: preferences)
                .preferredColorScheme(preferences.appearance.colorScheme)
        }
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }

    func showHelp() {
        let alert = NSAlert()
        alert.messageText = "FlowState scaffold"
        alert.informativeText =
            "Explore the dashboard, sound settings, insights and history. Appearance and Focus tuning are saved locally. Timer, audio playback and statistics arrive in later implementation steps. Close the window to keep the menu bar available; use Quit to exit."
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
