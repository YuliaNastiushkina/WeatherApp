
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel(networkService: URLSession.shared)
    
    var body: some View {
        VStack(spacing: 20) {
            
            SearchView(viewModel: viewModel)
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                WeatherView(viewModel: viewModel)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
