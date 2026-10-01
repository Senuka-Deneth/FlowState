import SwiftUI

struct InsightsView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Your focus, over time", systemImage: "chart.bar.xaxis")
        } description: {
            Text(
                "Hourly focus, daily totals, completed blocks and sound usage will appear after the session ledger is implemented. No activity is being collected."
            )
        }
    }
}
