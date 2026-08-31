import SwiftUI

@main
struct GlassOpenClawApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  @StateObject private var loop = HandsFreeLoop()
  var body: some View {
    VStack(spacing: 16) {
      Text("Glass → OpenClaw").font(.title2.bold())
      Text("Grok is the hands on desktop-ej8jl1o. Keep this app running; it is the glasses Bluetooth I/O. OpenClaw chat app is not required.")
        .font(.footnote)
        .foregroundStyle(.secondary)
      Button(loop.listening ? "Listening…" : "Start hands-free") {
        loop.toggle()
      }
      .buttonStyle(.borderedProminent)
      Text(loop.status).font(.body).padding()
    }
    .padding()
  }
}
