import Foundation
import Combine
import Network

final class NetworkManager: ObservableObject {

    @Published var status = "NOT TESTED"
    @Published var lastResult = "Waiting..."

    private let port: NWEndpoint.Port = 60675
    private var connection: NWConnection?

    func testConnection(host: String) {

        connection?.cancel()

        DispatchQueue.main.async {
            self.status = "TESTING"
            self.lastResult = "Connecting to \(host):60675..."
        }

        guard let nwPort = NWEndpoint.Port(rawValue: port.rawValue) else {
            DispatchQueue.main.async {
                self.status = "FAILED"
                self.lastResult = "Invalid port"
            }
            return
        }

        let connection = NWConnection(
            host: NWEndpoint.Host(host),
            port: nwPort,
            using: .tcp
        )

        self.connection = connection

        connection.stateUpdateHandler = { [weak self] state in

            switch state {

            case .ready:

                DispatchQueue.main.async {
                    self?.status = "CONNECTED"
                    self?.lastResult = "TCP connection established"
                }

                let message = Data("PC_TEST\n".utf8)

                connection.send(
                    content: message,
                    completion: .contentProcessed { error in

                        if let error {
                            DispatchQueue.main.async {
                                self?.status = "FAILED"
                                self?.lastResult =
                                    "Send failed: \(error.localizedDescription)"
                            }
                            return
                        }

                        self?.receiveResponse(from: connection)
                    }
                )

            case .failed(let error):

                DispatchQueue.main.async {
                    self?.status = "FAILED"
                    self?.lastResult =
                        "TCP failed: \(error.localizedDescription)"
                }

            case .cancelled:

                DispatchQueue.main.async {
                    if self?.status == "TESTING" {
                        self?.status = "FAILED"
                        self?.lastResult = "Connection cancelled"
                    }
                }

            default:
                break
            }
        }

        connection.start(
            queue: DispatchQueue(
                label: "GBoxResearch.Network"
            )
        )
    }

    private func receiveResponse(from connection: NWConnection) {

        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: 4096
        ) { [weak self] data, _, _, error in

            DispatchQueue.main.async {

                if let error {
                    self?.status = "FAILED"
                    self?.lastResult =
                        "Receive failed: \(error.localizedDescription)"

                    connection.cancel()
                    return
                }

                guard let data,
                      let response = String(
                          data: data,
                          encoding: .utf8
                      )
                else {
                    self?.status = "FAILED"
                    self?.lastResult =
                        "Invalid server response"

                    connection.cancel()
                    return
                }

                self?.status = "PASS"
                self?.lastResult =
                    response.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

                connection.cancel()
            }
        }
    }

    deinit {
        connection?.cancel()
    }
}
