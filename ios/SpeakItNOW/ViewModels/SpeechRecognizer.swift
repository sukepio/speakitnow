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
    case recording
    case processing
}

class SpeechRecognizer: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var state: SpeechState = .idle
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    private var hasInstalledTap = false
    
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
            Task {
                await checkPermissionsAndStartRecording()
            }
        case .recording:
            stopRecording()
        case .processing:
            return
        }
    }
    
    func clearRecognizedText() {
        recognizedText = ""
    }
    
    private func checkPermissionsAndStartRecording() async {
        guard await requestSpeechRecognitionPermission() else { return }
        guard await requestMicrophonePermission() else { return }
        guard speechRecognizer?.isAvailable == true else { return }
        
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
        resetSession()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("オーディオセッションの設定に失敗しました。")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object") }
        
        recognitionRequest.shouldReportPartialResults = false
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                    self?.recognitionRequest?.append(buffer)
                }
        hasInstalledTap = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            
            if let result, result.isFinal {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
                self.stopAudioInput()
                self.finishRecognition()
            } else if error != nil {
                self.stopAudioInput()
                self.finishRecognition()
            }
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.state = .recording
                self.recognizedText = ""
            }
        } catch {
            print("オーディオエンジンの起動に失敗しました。")
            self.stopAudioInput()
            self.finishRecognition()
        }
    }
    
    private func resetSession() {
        stopAudioInput()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
    }
    
    private func stopRecording() {
        self.stopAudioInput()
        
        DispatchQueue.main.async {
            self.state = .processing
        }
    }
    
    private func finishRecognition() {
        DispatchQueue.main.async {
            self.state = .idle
        }
        
        self.recognitionTask = nil
        self.recognitionRequest = nil
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
}
