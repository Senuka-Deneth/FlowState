import FocusDomain
import SwiftUI

struct DashboardView: View {
    private let configuration = TimerConfiguration.reference

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Label("Ready to focus", systemImage: "circle.dotted")
                    .font(.title3).foregroundStyle(.secondary)
                Text("50:00")
                    .font(.system(size: 88, weight: .light, design: .rounded))
                    .monospacedDigit().accessibilityLabel("50 minutes")
                Text("Focus · Block 1 of \(configuration.blocksPerCycle)")
                    .foregroundStyle(.secondary)
                Button("Start focus", systemImage: "play.fill") {}
                    .buttonStyle(.borderedProminent).controlSize(.large).disabled(true)
                Text("Timer controls arrive in the next implementation stage.")
                    .font(.callout).foregroundStyle(.secondary)
                HStack(spacing: 20) {
                    Label("10 min short break", systemImage: "cup.and.saucer")
                    Label("20 min long break", systemImage: "leaf")
                }
                .font(.callout)
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today").font(.headline)
                    Text("No focus time recorded")
                    Text(
                        "Your completed blocks and partial work will appear here once timing is available."
                    )
                    .font(.callout).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(36).frame(maxWidth: 660)
            .frame(maxWidth: .infinity)
        }
    }
}
