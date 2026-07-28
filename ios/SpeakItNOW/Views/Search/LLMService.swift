//
//  LLMService.swift
//  SpeakItNOW
//
//  Created by AI Assistant on 2026/07/26.
//

import Foundation

enum LLMConfig {
    static func defaultBaseURL() -> URL? {
        guard let string = Bundle.main.object(forInfoDictionaryKey: "LLM_API_BASE_URL") as? String,
              !string.isEmpty else {
            return nil
        }
        return URL(string: string)
    }

    static func defaultAPIKey() -> String? {
        Bundle.main.object(forInfoDictionaryKey: "LLM_API_KEY") as? String
    }
}

enum LLMServiceError: LocalizedError {
    case misconfigured(String)
    case authentication(Error)
    case network(URLError)
    case server(statusCode: Int, message: String?)
    case decoding(Error)
    case encoding(Error)
    case invalidResponse(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .misconfigured(let message):
            return message
        case .authentication(let error):
            return "認証に失敗しました。\(error.localizedDescription)"
        case .network(let error):
            return "通信に失敗しました。\(error.localizedDescription)"
        case .server(_, let message):
            return message ?? "サーバーでエラーが発生しました。"
        case .decoding:
            return "サーバーからの応答を読み取れませんでした。"
        case .encoding:
            return "リクエストを作成できませんでした。"
        case .invalidResponse(let message):
            return message
        case .unknown:
            return "予期しないエラーが発生しました。"
        }
    }
}

struct InstantCompositionGenerationRequest: Codable, Sendable {
    let phraseText: String
    let phraseMeaning: String
    let questionCount: Int
    let difficulty: String
    let scene: String
    let formalLevel: String
    let locale: String
}

struct InstantCompositionQuestion: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let questionJa: String
    let modelAnswerEn: String
}

struct InstantCompositionGenerationResponse: Codable, Sendable {
    let questions: [InstantCompositionQuestion]
}

struct InstantCompositionEvaluationRequest: Codable, Sendable {
    let phraseText: String
    let phraseMeaning: String
    let questionJa: String
    let modelAnswerEn: String
    let userAnswerEn: String
    let difficulty: String
    let locale: String
}

struct InstantCompositionEvaluationResponse: Codable, Sendable {
    let isPerfect: Bool
    let feedback: String?
    let alternativeAnswers: [String]
}

protocol LLMServiceProtocol: Sendable {
    func generateInstantComposition(
        request: InstantCompositionGenerationRequest
    ) async throws -> [InstantCompositionQuestion]

    func evaluateInstantCompositionAnswer(
        request: InstantCompositionEvaluationRequest
    ) async throws -> InstantCompositionEvaluationResponse
}

final class LLMService: LLMServiceProtocol {
    struct Configuration: Sendable {
        var baseURL: URL?
        var apiKey: String?
        var generationPath: String
        var evaluationPath: String

        init(
            baseURL: URL? = LLMConfig.defaultBaseURL(),
            apiKey: String? = LLMConfig.defaultAPIKey(),
            generationPath: String = "/functions/v1/instant-composition-generate",
            evaluationPath: String = "/functions/v1/instant-composition-evaluate"
        ) {
            self.baseURL = baseURL
            self.apiKey = apiKey
            self.generationPath = generationPath
            self.evaluationPath = evaluationPath
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
        self.decoder = JSONDecoder()
    }

    func generateInstantComposition(
        request: InstantCompositionGenerationRequest
    ) async throws -> [InstantCompositionQuestion] {
        let response: InstantCompositionGenerationResponse = try await post(
            path: configuration.generationPath,
            body: request
        )

        guard !response.questions.isEmpty else {
            throw LLMServiceError.invalidResponse("問題を生成できませんでした。もう一度お試しください。")
        }
        return response.questions
    }

    func evaluateInstantCompositionAnswer(
        request: InstantCompositionEvaluationRequest
    ) async throws -> InstantCompositionEvaluationResponse {
        try await post(path: configuration.evaluationPath, body: request)
    }

    private func post<Request: Encodable, Response: Decodable>(
        path: String,
        body: Request
    ) async throws -> Response {
        guard let baseURL = configuration.baseURL else {
            throw LLMServiceError.misconfigured("LLM_API_BASE_URLが設定されていません。")
        }

        let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let url = baseURL.appendingPathComponent(trimmedPath)

        let payload: Data
        do {
            payload = try encoder.encode(body)
        } catch {
            throw LLMServiceError.encoding(error)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let apiKey = configuration.apiKey, !apiKey.isEmpty {
            request.setValue(apiKey, forHTTPHeaderField: "apikey")
        }
        do {
            let accessToken = try await AuthenticationService.shared.accessToken()
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } catch {
            throw LLMServiceError.authentication(error)
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            request.setValue("SpeakItNOW/\(version)", forHTTPHeaderField: "X-Client-Info")
        }
        request.httpBody = payload

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            throw LLMServiceError.network(error)
        } catch {
            throw LLMServiceError.unknown
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw LLMServiceError.unknown
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw LLMServiceError.server(
                statusCode: httpResponse.statusCode,
                message: decodeServerMessage(from: data)
            )
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw LLMServiceError.decoding(error)
        }
    }

    private func decodeServerMessage(from data: Data) -> String? {
        struct FlatError: Decodable {
            let error: String?
            let message: String?
        }
        struct NestedError: Decodable {
            struct Details: Decodable {
                let message: String?
            }
            let error: Details
        }

        if let flat = try? decoder.decode(FlatError.self, from: data) {
            return flat.message ?? flat.error
        }
        return try? decoder.decode(NestedError.self, from: data).error.message
    }
}

enum LLMProvider {
    static let shared: any LLMServiceProtocol = LLMService()
}
