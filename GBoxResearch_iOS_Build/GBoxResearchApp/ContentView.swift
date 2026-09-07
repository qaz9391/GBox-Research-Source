import SwiftUI

struct ContentView: View {

    @StateObject private var network = NetworkManager()

    @State private var pcAddress = ""
    @State private var inputResult = "READY"

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 18) {

                    VStack(spacing: 4) {

                        Text("GBox Research")
                            .font(.largeTitle.bold())

                        Text("Personal Test  v0.1.0")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 12)


                    GroupBox("PC Connection") {

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Windows PC LAN Address")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            TextField(
                                "例如 192.168.1.100",
                                text: $pcAddress
                            )
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numbersAndPunctuation)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()


                            HStack {

                                Text("Status")

                                Spacer()

                                Text(network.status)
                                    .foregroundStyle(.secondary)
                            }


                            Button("Test Connection") {

                                let address =
                                    pcAddress.trimmingCharacters(
                                        in: .whitespacesAndNewlines
                                    )

                                guard !address.isEmpty else {

                                    network.status = "ERROR"
                                    network.lastResult =
                                        "Please enter PC LAN address"

                                    return
                                }

                                network.testConnection(
                                    host: address
                                )
                            }
                            .buttonStyle(.borderedProminent)


                            Text(network.lastResult)
                                .font(
                                    .system(
                                        .footnote,
                                        design: .monospaced
                                    )
                                )
                                .textSelection(.enabled)
                        }
                        .padding(.vertical, 6)
                    }


                    GroupBox("Input Test") {

                        VStack(alignment: .leading, spacing: 12) {

                            HStack {

                                Text("Status")

                                Spacer()

                                Text(inputResult)
                                    .foregroundStyle(.secondary)
                            }


                            NavigationLink("Start Test") {

                                InputTestView(
                                    result: $inputResult
                                )
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.vertical, 6)
                    }


                    GroupBox("Anti-Cheat Research") {

                        VStack(alignment: .leading, spacing: 12) {

                            HStack {

                                Text("Status")

                                Spacer()

                                Text("READY")
                                    .foregroundStyle(.secondary)
                            }


                            NavigationLink("Open Test") {

                                ResearchView()
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.vertical, 6)
                    }


                    GroupBox("Result") {

                        Text(network.lastResult)
                            .font(
                                .system(
                                    .body,
                                    design: .monospaced
                                )
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .textSelection(.enabled)
                            .padding(.vertical, 6)
                    }

                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
