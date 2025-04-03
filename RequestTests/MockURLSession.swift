import XCTest

class MockURLSession: RequestProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        return (mockData ?? Data(), mockResponse ?? URLResponse())
    }
}
