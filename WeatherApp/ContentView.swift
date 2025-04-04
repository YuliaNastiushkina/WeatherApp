
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel(networkService: URLSession.shared)
    
    var body: some View {
        VStack(spacing: 20) {
            
            SearchView(viewModel: viewModel)
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text(viewModel.temperature)
                    .font(.largeTitle)
                    .bold()
                
                Text(viewModel.feelsLike)
                    .font(.title)
                
                Text(viewModel.description)
                    .font(.title2)
                
                Text(viewModel.humidity)
                    .font(.body)
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
