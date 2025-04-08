import Foundation

/// Defines the properties required for weather data.
///
/// This protocol is used to ensure that any class or struct that handles weather data implements the necessary properties to store and manage basic weather information for a given city.
@MainActor
protocol WeatherDataProtocol {
    var cityName: String { get }
    var temperature: String { get }
    var weatherDescription: String { get }
    var feelsLike: String { get }
    var humidity: String { get }
}
