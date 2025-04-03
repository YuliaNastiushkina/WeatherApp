import XCTest

final class RequestTests: XCTestCase {
    var mockSession: MockURLSession!
    var request: Request!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        request = Request(networkService: mockSession)
    }
    
    override func tearDown() {
        mockSession = nil
        request = nil
        super.tearDown()
    }
    
    func testGetWeatherSuccess() async throws {
        let jsonString = """
        {
            "name": "Toronto",
            "main": {
                "temp": 25.0,
                "feels_like": 27.0,
                "humidity": 60
            },
            "weather": [{
                "main": "Clear",
                "description": "Clear sky",
        "icon": "01d"
            }]
        }
        """
        let data = jsonString.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        mockSession.mockData = data
        mockSession.mockResponse = response
        
        let weather = try await request.getWeather(for: "Toronto")
        
        XCTAssertEqual(weather.main.temp, 25.0)
        XCTAssertEqual(weather.main.feelsLike, 27.0)
        XCTAssertEqual(weather.main.humidity, 60)
        XCTAssertEqual(weather.weather.first?.description, "Clear sky")
    }
    
    func testGetWeather_NetworkError() async {
        mockSession.mockError = URLError(.notConnectedToInternet)
        
        do {
            _ = try await request.getWeather(for: "Toronto")
            XCTFail("Expected network error but got success")
        } catch {
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
    
    func testGetWeather_InvalidJSON() async {
        mockSession.mockData = "Invalid JSON".data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)!
        
        do {
            _ = try await request.getWeather(for: "Toronto")
            XCTFail("Expected JSON decoding error but got success")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testGetWeather_ServerError() async {
        let data = "{}".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org")!,
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        mockSession.mockData = data
        mockSession.mockResponse = response
        
        do {
            _ = try await request.getWeather(for: "Toronto")
            XCTFail("Expected bad server response error but got success")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
}
