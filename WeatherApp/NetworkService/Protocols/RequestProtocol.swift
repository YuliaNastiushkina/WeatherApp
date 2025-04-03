import Foundation

/// A protocol that abstracts network requests for testing and dependency injection.
/// Use this to mock `URLSession` in unit tests and provide custom network implementations.
protocol RequestProtocol {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}
