import FocusDomain
import SwiftUI

struct SoundLibraryView: View {
    @Bindable var model: AppModel
    @State private var structure = 0.5
    @State private var intensity = 0.5
    @State private var message = ""

    var body: some View {
        Form {
            Section {
                Label("Focus tuning", systemImage: "waveform")
                    .font(.title2)
                Text(
                    "Save your preferred balance for the future Focus sound. Audio playback and live preview are not available in this scaffold."
                )
                .foregroundStyle(.secondary)
            }
            Section("Structure") {
                Slider(value: $structure, in: 0...1) {
                    Text("Fluid to Structured")
                } minimumValueLabel: {
                    Text("Fluid")
                } maximumValueLabel: {
                    Text("Structured")
                }
                .accessibilityValue("\(Int(structure * 100)) percent structured")
                .accessibilityIdentifier("tuning.structure")
                TextField(
                    "Structure percentage", value: percentage($structure),
                    format: .percent.precision(.fractionLength(0))
                )
                .accessibilityIdentifier("tuning.structurePercentage")
            }
            Section("Intensity") {
                Slider(value: $intensity, in: 0...1) {
                    Text("Easy to Intense")
                } minimumValueLabel: {
                    Text("Easy")
                } maximumValueLabel: {
                    Text("Intense")
                }
                .accessibilityValue("\(Int(intensity * 100)) percent intense")
                TextField(
                    "Intensity percentage", value: percentage($intensity),
                    format: .percent.precision(.fractionLength(0)))
            }
            Section {
                HStack {
                    Button("Apply") {
                        Task {
                            guard
                                let tuning = try? FocusTuning(
                                    structure: structure, intensity: intensity)
                            else {
                                message = "Enter percentages from 0% to 100%."
                                return
                            }
                            message =
                                await model.saveTuning(tuning)
                                ? "Tuning saved on this Mac."
                                : "Tuning could not be saved. Try again."
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("tuning.apply")
                    Button("Cancel changes") {
                        resetDraft()
                        message = "Changes discarded."
                    }
                }
                Text(
                    message.isEmpty
                        ? "Apply saves these values. Cancel restores the last saved tuning."
                        : message
                )
                .font(.callout).foregroundStyle(.secondary)
                .accessibilityIdentifier("tuning.status")
            }
            .disabled(!model.storageReady || model.isSaving)
            Section("Sound catalog") {
                Text(
                    "Original sound recipes, independent listening and timed scenarios will be added after the audio prototype is validated."
                )
                .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .disabled(!model.storageReady || model.isSaving)
        .onAppear { resetDraft() }
        .onChange(of: model.storageReady) { _, _ in resetDraft() }
    }

    private func resetDraft() {
        structure = model.savedTuning.structure
        intensity = model.savedTuning.intensity
    }

    private func percentage(_ value: Binding<Double>) -> Binding<Double> {
        Binding(
            get: { value.wrappedValue },
            set: { proposed in
                guard proposed.isFinite, (0...1).contains(proposed) else {
                    message = "Enter percentages from 0% to 100%."
                    return
                }
                value.wrappedValue = proposed
                message = ""
            }
        )
    }
}
