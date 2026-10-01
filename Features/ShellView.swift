import SwiftUI

struct ShellView: View {
    @Bindable var model: AppModel
    @Bindable var preferences: Preferences

    var body: some View {
        NavigationSplitView {
            List(AppSection.allCases, selection: $model.selection) { section in
                Label(section.rawValue, systemImage: section.symbol)
                    .tag(section)
                    .accessibilityIdentifier("nav.\(section.id)")
            }
            .navigationTitle("FlowState")
            .navigationSplitViewColumnWidth(min: 180, ideal: 210)
            .safeAreaInset(edge: .bottom) {
                Text("Development preview")
                    .font(.caption).foregroundStyle(.secondary).padding()
            }
        } detail: {
            Group {
                switch model.selection ?? .dashboard {
                case .dashboard: DashboardView()
                case .sounds: SoundLibraryView(model: model)
                case .insights: InsightsView()
                case .history: HistoryView(model: model)
                }
            }
            .navigationTitle((model.selection ?? .dashboard).rawValue)
            .toolbar { SettingsLink { Label("Settings", systemImage: "gearshape") } }
            .safeAreaInset(edge: .bottom) {
                if model.storageError {
                    HStack {
                        Label(
                            "Local storage is unavailable. Your data has not been reset.",
                            systemImage: "exclamationmark.triangle")
                        if !model.storageReady {
                            Button("Retry") { Task { await model.start() } }
                                .disabled(model.isLoading)
                        }
                    }
                    .font(.callout).padding().frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                }
            }
        }
        .frame(minWidth: 760, minHeight: 560)
        .sheet(
            isPresented: Binding(
                get: { !preferences.completedOnboarding },
                set: { if !$0 { preferences.completedOnboarding = true } }
            )
        ) {
            OnboardingView { preferences.completedOnboarding = true }
                .interactiveDismissDisabled()
        }
    }
}

private struct OnboardingView: View {
    let finish: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: "timer").font(.system(size: 40)).foregroundStyle(.tint)
            Text("A place for focused work").font(.largeTitle.bold())
            Text("A native home for focus sessions, evolving sound and a clear view of your time.")
            Label("Your settings stay on this Mac", systemImage: "internaldrive")
            Label("No account or permissions needed to explore", systemImage: "lock.shield")
            Text(
                "This is the first scaffold. You can explore every screen and save sound tuning. Timing and audio playback are not available yet."
            )
            .foregroundStyle(.secondary)
            Button("Explore FlowState", action: finish)
                .buttonStyle(.borderedProminent).controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .accessibilityIdentifier("onboarding.continue")
        }
        .padding(36).frame(width: 480)
    }
}
