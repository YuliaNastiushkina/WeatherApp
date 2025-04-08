import Foundation
import SwiftData

/// A model representing saved weather data for a specific city.
@Model
class SavedWeathersModel: WeatherDataProtocol {
    var cityName: String { city }
    
    /// The name of the city.
    var city: String
    /// The current temperature in Celsius.
    var temperature: String
    /// A detailed description of the current weather condition (e.g., "clear sky").
    var weatherDescription: String
    /// The feels-like temperature in Celsius.
    var feelsLike: String
    /// Humidity in percentage.
    var humidity: String
    
    init(city: String, temperature: String, description: String, feelsLike: String, humidity: String) {
        self.city = city
        self.temperature = temperature
        self.weatherDescription = description
        self.feelsLike = feelsLike
        self.humidity = humidity
    }
}
