import SwiftUI

struct InputTestView: View {
    @Binding var result: String

    @State private var events = 0
    @State private var activeTouches = 0
    @State private var maxTouches = 0
    @State private var started = false

    var body: some View {
        VStack(spacing: 20) {

            Text("Input Test")
                .font(.title.bold())

            Text("Touch inside the test area.")
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                .overlay(
                    Text(started ? "RECORDING" : "READY")
                        .font(.headline)
                )
                .frame(height: 260)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !started {
                                started = true
                            }

                            events += 1
                            activeTouches = 1
                            maxTouches = max(maxTouches, activeTouches)
                        }
                        .onEnded { _ in
                            activeTouches = 0
                        }
                )

            VStack(alignment: .leading, spacing: 8) {
                Text("Events: \(events)")
                Text("Active Touches: \(activeTouches)")
                Text("Max Concurrent Touches: \(maxTouches)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button("Finish Test") {
                result = events > 0 ? "PASS" : "NO INPUT"
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Input Test")
    }
}
