import SwiftUI

/// A wrapper view that initializes and provides the `WeatherViewModel` and `SavedWeatherViewModel` for the main content view.
/// This view does not perform any business logic but acts as a bridge to instantiate and inject the required view models
/// into the `ContentView`.
struct ContentViewWrapper: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        ContentView(
            viewModel: WeatherViewModel(networkService: URLSession.shared),
            savedViewModel: SavedWeatherViewModel(modelContext: modelContext)
        )
    }
}

#Preview {
    ContentViewWrapper()
}
