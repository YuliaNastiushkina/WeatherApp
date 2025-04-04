import Foundation

class MockURLSession: RequestProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    init(mockData: Data? = nil, mockResponse: URLResponse? = nil, mockError: Error? = nil) {
            self.mockData = mockData
            self.mockResponse = mockResponse
            self.mockError = mockError
        }

    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        return (mockData ?? Data(), mockResponse ?? URLResponse())
    }
}
