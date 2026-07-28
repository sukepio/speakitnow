//
//  SpeechRecognizer.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/25.
//

import Foundation
import Speech
import AVFoundation

enum SpeechState {
    case idle
    case preparing
    case recording
    case processing
}

@MainActor
final class SpeechRecognizer: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var state: SpeechState = .idle
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    private var hasInstalledTap = false
    private var recognitionSessionId: UUID?
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized.")
                default:
                    print("Speech recognition not authorized.")
                }
            }
        }
    }
    
    func toggleRecording() {
        switch state {
        case .idle:
            state = .preparing
            Task {
                await checkPermissionsAndStartRecording()
            }
        case .recording:
            stopRecording()
        case .preparing, .processing:
            return
        }
    }

    func cancelRecording() {
        resetSession()
        deactivateAudioSession()
        state = .idle
    }
    
    func clearRecognizedText() {
        recognizedText = ""
    }
    
    private func checkPermissionsAndStartRecording() async {
        guard await requestSpeechRecognitionPermission() else {
            state = .idle
            return
        }
        guard state == .preparing else { return }
        guard await requestMicrophonePermission() else {
            state = .idle
            return
        }
        guard state == .preparing else { return }
        guard speechRecognizer?.isAvailable == true else {
            state = .idle
            return
        }
        
        startRecording()
    }
    
    private func requestSpeechRecognitionPermission() async -> Bool {
        let status = SFSpeechRecognizer.authorizationStatus()
        
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { newStatus in
                    continuation.resume(returning: newStatus == .authorized)
                }
            }
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    private func requestMicrophonePermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }
    
    private func startRecording() {
        guard state == .preparing else { return }
        resetSession()
        audioEngine = AVAudioEngine()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("オーディオセッションの設定に失敗しました。")
            state = .idle
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object") }
        
        recognitionRequest.shouldReportPartialResults = false
        let recognitionSessionId = UUID()
        self.recognitionSessionId = recognitionSessionId
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        hasInstalledTap = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard result?.isFinal == true || error != nil else { return }

            Task { @MainActor [weak self] in
                guard let self,
                      self.recognitionSessionId == recognitionSessionId else {
                    return
                }

                if let result, result.isFinal {
                    self.recognizedText = result.bestTranscription.formattedString
                }
                self.stopAudioInput()
                self.finishRecognition()
            }
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            state = .recording
            recognizedText = ""
        } catch {
            print("オーディオエンジンの起動に失敗しました。")
            self.stopAudioInput()
            self.finishRecognition()
        }
    }
    
    private func resetSession() {
        recognitionSessionId = nil
        stopAudioInput()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
    }
    
    private func stopRecording() {
        stopAudioInput()
        state = .processing
    }
    
    private func finishRecognition() {
        recognitionSessionId = nil
        recognitionTask = nil
        recognitionRequest = nil
        deactivateAudioSession()
        state = .idle
    }
    
    private func stopAudioInput() {
        if hasInstalledTap {
            audioEngine.inputNode.removeTap(onBus: 0)
            hasInstalledTap = false
        }
        
        recognitionRequest?.endAudio()
        
        if audioEngine.isRunning {
            audioEngine.stop()
        }
    }

    private func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }
}
