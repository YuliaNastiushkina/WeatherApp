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

//
//class MockURLProtocol: URLProtocol {
//    override class func canInit(with request: URLRequest) -> Bool {
//        return true
//    }
//    
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//    
//    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
//    
//    override func startLoading() {
//        guard let handler = MockURLProtocol.requestHandler else {
//            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
//            return
//            //            XCTFail("No request handler provided")
//            //            return
//        }
//        
//        do {
//            let (response, data) = try handler(request)
//            
//            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
//            client?.urlProtocol(self, didLoad: data)
//            client?.urlProtocolDidFinishLoading(self)
//        } catch {
//            client?.urlProtocol(self, didFailWithError: error)
//            //            XCTFail("Error handling the request: \(error)")
//        }
//    }
//    
//    override func stopLoading() {}
//}
