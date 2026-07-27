//
//  LLMService.swift
//  SpeakItNOW
//
//  Created by AI Assistant on 2026/07/26.
//

import Foundation

// MARK: - Configuration

enum LLMConfig {
    /// Reads base URL from Info.plist key: `LLM_API_BASE_URL`.
    ///
    /// Example options:
    ///  - https://<project-ref>.supabase.co (use compositionPath "/functions/v1/<name>")
    ///  - https://<project-ref>.functions.supabase.co (use compositionPath "/<name>")
    static func defaultBaseURL() -> URL? {
        guard let string = Bundle.main.object(forInfoDictionaryKey: "LLM_API_BASE_URL") as? String,
              !string.isEmpty,
              let url = URL(string: string) else {
            return nil
        }
        return url
    }

    /// Reads API Key from Info.plist key: `LLM_API_KEY`.
    /// Use anon key on client. Never ship service role key in the app.
    static func defaultAPIKey() -> String? {
        Bundle.main.object(forInfoDictionaryKey: "LLM_API_KEY") as? String
    }
}

// MARK: - Errors

enum LLMServiceError: LocalizedError {
    case misconfigured(String)
    case network(URLError)
    case server(statusCode: Int, message: String?)
    case decoding(Error)
    case encoding(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .misconfigured(let message):
            return message
        case .network(let urlError):
            return urlError.localizedDescription
        case .server(let statusCode, let message):
            return message ?? "Server error (status: \(statusCode))"
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encoding(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error"
        }
    }
}

extension LLMServiceError: Equatable {
    static func == (lhs: LLMServiceError, rhs: LLMServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.misconfigured(let a), .misconfigured(let b)):
            return a == b
        case (.network(let a), .network(let b)):
            return a.code == b.code
        case (.server(let s1, let m1), .server(let s2, let m2)):
            return s1 == s2 && m1 == m2
        case (.decoding, .decoding):
            // Associated Error isn't Equatable; treat same-case as equal for comparison purposes
            return true
        case (.encoding, .encoding):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}

// MARK: - Models

struct InstantCompositionRequest: Codable, Sendable {
    let phraseText: String
    let phraseMeaning: String?
    let questionCount: Int
    let difficulty: String
    let scene: String
    let formalLevel: String
    let locale: String?
}

struct InstantCompositionQuestion: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let en: String
    let ja: String?
}

struct InstantCompositionResponse: Codable, Sendable {
    let questions: [InstantCompositionQuestion]
}

// MARK: - Protocol

protocol LLMServiceProtocol: Sendable {
    func generateInstantComposition(
        phraseText: String,
        phraseMeaning: String?,
        questionCount: Int,
        difficulty: String,
        scene: String,
        formalLevel: String,
        locale: String?
    ) async throws -> [InstantCompositionQuestion]
}

// MARK: - Service

final class LLMService: LLMServiceProtocol {
    struct Configuration: Sendable {
        var baseURL: URL?
        var apiKey: String?
        var compositionPath: String

        init(
            baseURL: URL? = LLMConfig.defaultBaseURL(),
            apiKey: String? = LLMConfig.defaultAPIKey(),
            compositionPath: String = "/functions/v1/instant-composition"
        ) {
            self.baseURL = baseURL
            self.apiKey = apiKey
            self.compositionPath = compositionPath
        }
    }

    private let session: URLSession
    private let configuration: Configuration
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(configuration: Configuration = Configuration(), session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
        self.encoder = JSONEncoder()
        self.encoder.keyEncodingStrategy = .useDefaultKeys
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .useDefaultKeys
    }

    func generateInstantComposition(
        phraseText: String,
        phraseMeaning: String?,
        questionCount: Int,
        difficulty: String,
        scene: String,
        formalLevel: String,
        locale: String? = Locale.current.identifier
    ) async throws -> [InstantCompositionQuestion] {
        guard let baseURL = configuration.baseURL else {
            throw LLMServiceError.misconfigured("Missing Info.plist key: LLM_API_BASE_URL")
        }

        // Build URL
        let trimmedPath = configuration.compositionPath.hasPrefix("/") ? String(configuration.compositionPath.dropFirst()) : configuration.compositionPath
        let url = baseURL.appendingPathComponent(trimmedPath)

        // Build request body
        let body = InstantCompositionRequest(
            phraseText: phraseText,
            phraseMeaning: phraseMeaning,
            questionCount: questionCount,
            difficulty: difficulty,
            scene: scene,
            formalLevel: formalLevel,
            locale: locale
        )

        let payload: Data
        do {
            payload = try encoder.encode(body)
        } catch {
            throw LLMServiceError.encoding(error)
        }

        // Build URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let apiKey = configuration.apiKey, !apiKey.isEmpty {
            // Supabase Edge Functions commonly expect both Authorization and apikey headers.
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue(apiKey, forHTTPHeaderField: "apikey")
            // Keep a custom header for observability if desired.
            request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            request.setValue("SpeakItNOW/\(version)", forHTTPHeaderField: "X-Client-Info")
        }
        request.httpBody = payload

        // Perform request
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError {
            throw LLMServiceError.network(urlError)
        } catch {
            throw LLMServiceError.unknown
        }

        guard let http = response as? HTTPURLResponse else {
            throw LLMServiceError.unknown
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = try? decodeServerMessage(from: data)
            throw LLMServiceError.server(statusCode: http.statusCode, message: message)
        }

        // Decode success: accept either { "questions": [...] } or plain array
        if let wrapper = try? decoder.decode(InstantCompositionResponse.self, from: data) {
            return wrapper.questions
        } else if let array = try? decoder.decode([InstantCompositionQuestion].self, from: data) {
            return array
        } else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Unexpected response shape")
            throw LLMServiceError.decoding(DecodingError.dataCorrupted(context))
        }
    }

    private func decodeServerMessage(from data: Data) throws -> String? {
        struct Err: Decodable { let error: String?; let message: String?; let detail: String?; let msg: String? }
        let decoded = try? decoder.decode(Err.self, from: data)
        return decoded?.error ?? decoded?.message ?? decoded?.detail ?? decoded?.msg
    }
}

// MARK: - Provider

enum LLMProvider {
    static var shared: any LLMServiceProtocol = LLMService()
}
