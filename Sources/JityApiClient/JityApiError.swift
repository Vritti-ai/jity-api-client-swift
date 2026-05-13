import Foundation

public enum JityApiError: Error, LocalizedError {
    case missingCredentials
    case httpError(statusCode: Int, details: Any?)
    case decodingError(Error)
    case networkError(Error)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "clientId and apiKey are required."
        case .httpError(let statusCode, _):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
