//import XCTest
//
//final class RequestTests: XCTestCase {
//    var session: URLSession!
//    var request: Request!
//    
//    override func setUpWithError() throws {
//        let config = URLSessionConfiguration.ephemeral
//        config.protocolClasses = [MockURLProtocol.self]
//        session = URLSession(configuration: config)
//        
//        request = Request(session: session)
//        
//        MockURLProtocol.requestHandler = { request in
//            let json = """
//                        {
//                            "weather": [{"description": "clear sky"}],
//                            "main": {
//                                "temp": 23.5
//                            }
//                        }
//                    """
//            let data = json.data(using: .utf8)!
//            let response = HTTPURLResponse(
//                url: request.url!,
//                statusCode: 200,
//                httpVersion: nil,
//                headerFields: nil
//            )!
//            return (response, data)
//        }
//    }
//    
//    override func tearDownWithError() throws {
//        MockURLProtocol.requestHandler = nil
//        session = nil
//        request = nil
//    }
//    
//    func testGetWeather() async throws {
//        do {
//            let weather = try await request.getWeather(for: "Toronto")
//            XCTAssertEqual(weather.main.temp, 23.5)
//            XCTAssertEqual(weather.weather.first?.description, "clear sky")
//        } catch {
//            XCTFail("Unexpected error: \(error)")
//        }
//    }
//}
