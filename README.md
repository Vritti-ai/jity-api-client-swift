# JityApiClient

Official Swift client for the [Jity](https://wity.ai) Content API. Search and filter your content programmatically from iOS and iPadOS apps.

## Requirements

- iOS 15+ / iPadOS 15+
- Swift 5.9+

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies**, then enter:

```
https://github.com/wityai/jity-api-client-swift
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/wityai/jity-api-client-swift", from: "1.0.0")
]
```

## Getting Started

```swift
import JityApiClient

let api = try JityContentApi(options: .init(
    clientId: "your-client-id",
    apiKey:   "your-api-key"
))
```

Your `clientId` and `apiKey` are available in your [Jity dashboard](https://wity.ai).

## Usage

### Search posts

Call `searchPosts` with any combination of filters. All parameters are optional — omitting them returns all posts.

```swift
let response = try await api.searchPosts()

if let posts = response.data {
    for post in posts {
        print(post.title)
    }
}
```

#### Filter by date range

```swift
let response = try await api.searchPosts(payload: .init(
    startDate: "2024-01-01",
    endDate:   "2024-06-30"
))
```

#### Filter by content type or format

```swift
let response = try await api.searchPosts(payload: .init(
    contentType: "article",
    postFormat:  "long-form"
))
```

#### Full-text search

```swift
let response = try await api.searchPosts(payload: .init(
    searchText: "product launch"
))
```

#### Filter by label and tags

```swift
let response = try await api.searchPosts(payload: .init(
    contentLabel: "marketing",
    customTags:   ["q1", "campaign"]
))
```

#### Combining filters

```swift
let response = try await api.searchPosts(payload: .init(
    startDate:    "2024-01-01",
    contentType:  "article",
    searchText:   "product launch",
    customTags:   ["q1"]
))
```

### JityApiPayload parameters

| Parameter      | Type       | Description                        |
|----------------|------------|------------------------------------|
| `startDate`    | `String?`  | Filter posts on or after this date (`YYYY-MM-DD`) |
| `endDate`      | `String?`  | Filter posts on or before this date (`YYYY-MM-DD`) |
| `contentType`  | `String?`  | Filter by content type             |
| `postFormat`   | `String?`  | Filter by post format              |
| `searchText`   | `String?`  | Full-text search across posts      |
| `contentLabel` | `String?`  | Filter by content label            |
| `customTags`   | `[String]?`| Filter by one or more custom tags  |

## Error handling

```swift
do {
    let response = try await api.searchPosts(payload: .init(searchText: "launch"))
} catch let error as JityApiError {
    switch error {
    case .httpError(let statusCode, _):
        print("API error: \(statusCode)")
    case .networkError(let underlying):
        print("Network error: \(underlying)")
    default:
        print(error.localizedDescription)
    }
}
```

## Debugging

Enable request/response logging during development:

```swift
let api = try JityContentApi(options: .init(
    clientId:      "your-client-id",
    apiKey:        "your-api-key",
    enableLogging: true
))
```

## License

MIT
