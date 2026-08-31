import Foundation
import AVFoundation

/// Glasses-attached DAT companion: POST to OpenClaw Gateway, poll inbox, speak on BT glasses.
/// Does not run Muse Spark on the glasses OS (not possible). Muse cloud voice = Meta AI app.
enum GlassOpenClawBridge {
  static let origin = "https://desktop-ej8jl1o.tailfdcf6f.ts.net"
  static let hook = URL(string: "\(origin)/hooks/glass")!
  static let session = "hook:glass"

  struct Job: Decodable {
    let id: String?
    let jobId: String?
    let status: String?
    let done: Bool?
    let voice: String?
    let answer: String?
    let museSparkContinue: String?
  }

  static func postToGrok(enriched: String) async throws -> String {
    var text = enriched.trimmingCharacters(in: .whitespacesAndNewlines)
    if !text.lowercased().hasPrefix("from muse spark orchestrator:") {
      text =
        "From Muse Spark orchestrator: memory: Ty likes dark mode; liveEyes; handsFree; hostIsGlasses. " +
        "User intent: \(text). Session hook:glass sticky."
    }
    var req = URLRequest(url: hook)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = try JSONSerialization.data(withJSONObject: [
      "hook": "glass",
      "sessionId": session,
      "from": "muse-spark-orchestrator",
      "device": "rayban-meta-gen2",
      "text": text,
    ])
    let (data, _) = try await URLSession.shared.data(for: req)
    let job = try JSONDecoder().decode(Job.self, from: data)
    guard let id = job.jobId ?? job.id else { throw URLError(.badServerResponse) }
    return id
  }

  static func pollInbox(id: String, timeout: TimeInterval = 120) async throws -> Job {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
      let url = URL(string: "\(origin)/glass/inbox/\(id)")!
      let (data, _) = try await URLSession.shared.data(from: url)
      let job = try JSONDecoder().decode(Job.self, from: data)
      if job.done == true || job.status == "done" || job.status == "error" { return job }
      try await Task.sleep(nanoseconds: 1_000_000_000)
    }
    throw URLError(.timedOut)
  }

  static func speakOnGlasses(_ text: String) {
    let u = AVSpeechUtterance(string: String(text.prefix(2000)))
    u.voice = AVSpeechSynthesisVoice(language: "en-US")
    AVSpeechSynthesizer().speak(u)
  }

  /// Phone/glasses I/O path. Muse cloud voice still needs Meta AI + last-continue.
  static func runHandsFree(userHeard: String) async {
    do {
      let id = try await postToGrok(enriched: userHeard)
      let job = try await pollInbox(id: id)
      let voice = job.voice ?? job.answer ?? "done"
      speakOnGlasses(voice)
    } catch {
      speakOnGlasses("OpenClaw bridge error")
    }
  }
}
