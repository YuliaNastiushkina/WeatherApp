import Foundation

/// Describes the overall structure of the weather data model.
struct WeatherModel: Decodable {
    /// The name of the city.
    let name: String
    /// Main weather data, such as temperature and feels-like temperature.
    let main: Main
    /// A list of weather conditions.
    let weather: [Weather]
    /// Humidity in percentage.
    let humidity: Int
    
    /// Represents main weather parameters like temperature and feels-like temperature.
    struct Main: Decodable {
        /// The current temperature in Celsius.
        let temp: Double
        /// The feels-like temperature in Celsius.
        let feelsLike: Double
        
        /// Mapping of JSON keys to the property names in Swift.
        /// This is used to map the JSON key `feels_like` to the property `feelsLike`.
        private enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
        }
    }
    
    /// Provides weather conditions, such as the main condition and description.
    struct Weather: Decodable {
        /// The main weather condition (e.g., "Clear", "Rain").
        let main: String
        /// A detailed description of the current weather condition (e.g., "clear sky", "light rain").
        let description: String
        /// An icon representing the current weather condition.
        let icon: String
    }
}
