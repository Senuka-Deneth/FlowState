import SwiftUI

struct SettingsView: View {
    @Bindable var preferences: Preferences

    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Appearance", selection: $preferences.appearance) {
                    ForEach(AppAppearance.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
            }
            Section("Timer preset") {
                LabeledContent("Focus", value: "50 minutes")
                LabeledContent("Short / long break", value: "10 / 20 minutes")
                LabeledContent("Long break cadence", value: "4 completed blocks")
                Text(
                    "Reference-aligned starting values. Configurable timing and manual phase transitions arrive with the timer engine."
                )
                .font(.callout).foregroundStyle(.secondary)
            }
            Section("Privacy & Mac integration") {
                Text(
                    "No app or website tracking, notifications, login item, or sync is enabled. Optional integrations will request access when you choose to enable them."
                )
                Text(
                    "Preferences and sound tuning are stored locally. History retention and data export controls arrive with the session ledger."
                )
                .foregroundStyle(.secondary)
            }
            Section {
                Button("Show introduction again") { preferences.completedOnboarding = false }
            }
        }
        .formStyle(.grouped).padding()
        .frame(width: 540, height: 540)
    }
}
