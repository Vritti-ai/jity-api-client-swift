import Foundation

public struct JityContentApiOptions {
    public let clientId: String
    public let apiKey: String
    public let apiHost: String
    public let enableLogging: Bool

    public init(
        clientId: String,
        apiKey: String,
        apiHost: String = "https://api.wity.ai",
        enableLogging: Bool = false
    ) {
        self.clientId = clientId
        self.apiKey = apiKey
        self.apiHost = apiHost
        self.enableLogging = enableLogging
    }
}

public struct JityApiPayload {
    public var startDate: String?
    public var endDate: String?
    public var contentType: String?
    public var postFormat: String?
    public var searchText: String?
    public var contentLabel: String?
    public var customTags: [String]?

    public init(
        startDate: String? = nil,
        endDate: String? = nil,
        contentType: String? = nil,
        postFormat: String? = nil,
        searchText: String? = nil,
        contentLabel: String? = nil,
        customTags: [String]? = nil
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.contentType = contentType
        self.postFormat = postFormat
        self.searchText = searchText
        self.contentLabel = contentLabel
        self.customTags = customTags
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let v = startDate    { items.append(.init(name: "startDate",    value: v)) }
        if let v = endDate      { items.append(.init(name: "endDate",      value: v)) }
        if let v = contentType  { items.append(.init(name: "contentType",  value: v)) }
        if let v = postFormat   { items.append(.init(name: "postFormat",   value: v)) }
        if let v = searchText   { items.append(.init(name: "searchText",   value: v)) }
        if let v = contentLabel { items.append(.init(name: "contentLabel", value: v)) }
        customTags?.forEach { tag in
            items.append(.init(name: "customTags[]", value: tag))
        }
        return items
    }
}

public struct JityApiResponse<T: Decodable>: Decodable {
    public let success: Bool
    public let data: T?
    public let error: String?
}

public struct JityContentItem: Decodable {
    public let id: String
    public let title: String
    public let contentType: String
    public let postFormat: String
    public let createdAt: String
}
