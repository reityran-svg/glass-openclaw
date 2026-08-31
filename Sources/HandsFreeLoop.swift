import AVFoundation
import Foundation
import Speech

/// On-device STT (Apple), HTTPS to OpenClaw Gateway, poll inbox, speak on glasses BT.
/// Muse Spark 1.1 cloud TTS still lives in Meta AI via /glass/last-continue.
@MainActor
final class HandsFreeLoop: ObservableObject {
  @Published var listening = false
  @Published var status = "Idle"
  private let speech = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
  private var audio: AVAudioEngine?
  private var request: SFSpeechAudioBufferRecognitionRequest?
  private var task: SFSpeechRecognitionTask?
  private let wakes = ["hey grok", "hey meta", "what do you see", "look at this", "tell grok"]

  func toggle() {
    if listening { stop(); return }
    start()
  }

  func start() {
    SFSpeechRecognizer.requestAuthorization { _ in }
    AVAudioSession.sharedInstance().requestRecordPermission { _ in }
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.allowBluetooth, .defaultToSpeaker])
      try session.setActive(true)
    } catch {
      status = "Audio session failed"
      return
    }
    let engine = AVAudioEngine()
    let req = SFSpeechAudioBufferRecognitionRequest()
    req.shouldReportPartialResults = false
    let input = engine.inputNode
    let fmt = input.outputFormat(forBus: 0)
    input.installTap(onBus: 0, bufferSize: 1024, format: fmt) { buf, _ in
      req.append(buf)
    }
    engine.prepare()
    try? engine.start()
    audio = engine
    request = req
    listening = true
    status = "Listening on-device (not Meta cloud)"
    task = speech?.recognitionTask(with: req) { [weak self] result, _ in
      guard let self, let t = result?.bestTranscription.formattedString else { return }
      let low = t.lowercased()
      if self.wakes.contains(where: { low.contains($0) }) {
        Task { await self.sendToPc(t) }
      }
    }
  }

  func stop() {
    task?.cancel()
    request?.endAudio()
    audio?.inputNode.removeTap(onBus: 0)
    audio?.stop()
    listening = false
    status = "Stopped"
  }

  func sendToPc(_ heard: String) async {
    status = "Sending to Grok…"
    do {
      let id = try await GlassOpenClawBridge.postToGrok(enriched: heard)
      let job = try await GlassOpenClawBridge.pollInbox(id: id)
      let voice = job.voice ?? job.answer ?? "done"
      status = voice
      GlassOpenClawBridge.speakOnGlasses(voice)
    } catch {
      status = "Bridge error"
    }
  }
}
