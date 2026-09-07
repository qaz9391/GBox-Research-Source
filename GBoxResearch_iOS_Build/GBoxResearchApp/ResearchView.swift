import SwiftUI

struct ResearchView: View {
    var body: some View {
        List {
            Section("Research Status") {
                Label("Static Analysis", systemImage: "checkmark.circle")
                Label("Mach-O Evidence", systemImage: "checkmark.circle")
                Label("Baseline Diff", systemImage: "checkmark.circle")
            }

            Section("Current Baseline") {
                Text("clean_baseline.bin")
                Text("0 unique evidence")
                    .foregroundStyle(.secondary)
            }

            Section("Research Samples") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("AWSCognito")
                        .font(.headline)
                    Text("8 unique evidence  3 rules  8/8 resolved")
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("UnityFramework")
                        .font(.headline)
                    Text("6 unique evidence  3 rules  6/6 resolved")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Interpretation") {
                Text(
                    "Static evidence does not by itself prove runtime execution."
                )
            }
        }
        .navigationTitle("Anti-Cheat Research")
    }
}
