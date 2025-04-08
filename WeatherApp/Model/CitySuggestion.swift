import Foundation

/// Represents a suggested city with its name and country.
/// This struct is used to hold information about a city suggestion during city searches.
struct CitySuggestion: Codable {
    let name: String
    let country: String
}
