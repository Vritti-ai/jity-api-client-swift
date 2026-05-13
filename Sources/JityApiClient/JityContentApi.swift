import Foundation

public final class JityContentApi {
    private let baseURL: URL
    private let authHeader: String
    private let enableLogging: Bool
    private let session: URLSession

    public init(options: JityContentApiOptions) throws {
        guard !options.clientId.isEmpty, !options.apiKey.isEmpty else {
            throw JityApiError.missingCredentials
        }
        guard let url = URL(string: options.apiHost) else {
            throw JityApiError.unknown
        }

        self.baseURL = url
        self.enableLogging = options.enableLogging
        self.session = .shared

        let credentials = "\(options.clientId):\(options.apiKey)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        self.authHeader = "Basic \(encoded)"
    }

    public func listPosts(payload: JityApiPayload = .init()) async throws -> JityApiResponse<[JityContentItem]> {
        var components = URLComponents(url: baseURL.appendingPathComponent("list-posts"), resolvingAgainstBaseURL: false)!
        let queryItems = payload.queryItems
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else { throw JityApiError.unknown }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")

        if enableLogging {
            print("➡️ [Request] GET \(url)")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            if enableLogging { print("❌ [Network Error] \(error)") }
            throw JityApiError.networkError(error)
        }

        if let http = response as? HTTPURLResponse {
            if enableLogging {
                print("✅ [Response] \(http.statusCode) \(url)")
            }
            guard (200...299).contains(http.statusCode) else {
                let details = try? JSONSerialization.jsonObject(with: data)
                if enableLogging { print("❌ [Error Response] \(http.statusCode)") }
                throw JityApiError.httpError(statusCode: http.statusCode, details: details)
            }
        }

        do {
            return try JSONDecoder().decode(JityApiResponse<[JityContentItem]>.self, from: data)
        } catch {
            throw JityApiError.decodingError(error)
        }
    }
}
