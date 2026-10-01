import AppKit
import SwiftUI

struct MenuBarView: View {
    let model: AppModel
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Text("Focus · 50:00 · Ready")
        Text("Timer not yet available")
        Divider()
        ForEach(AppSection.allCases) { section in
            Button(section.rawValue) {
                model.selection = section
                openWindow(id: "dashboard")
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        SettingsLink()
        Divider()
        Button("Quit FlowState") { NSApp.terminate(nil) }.keyboardShortcut("q")
    }
}
