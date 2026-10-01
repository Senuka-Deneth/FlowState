import SwiftUI

struct HistoryView: View {
    @Bindable var model: AppModel

    var body: some View {
        if model.isLoading {
            ProgressView("Opening local history…")
        } else if !model.storageReady {
            ContentUnavailableView(
                "History unavailable", systemImage: "exclamationmark.triangle",
                description: Text("Local history could not be opened. Use Retry below."))
        } else if model.sessions.isEmpty {
            ContentUnavailableView(
                "No sessions yet", systemImage: "clock.arrow.circlepath",
                description: Text(
                    "Future focus sessions and interrupted work will appear here. Nothing has been added to your history."
                ))
        } else {
            List(model.sessions) { session in
                VStack(alignment: .leading) {
                    Text(session.phase.rawValue)
                    Text(session.startedAt, format: .dateTime.month().day().hour().minute())
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
