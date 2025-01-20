
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter city", text: $viewModel.cityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    Task {
                        await viewModel.fetchWeather()
                    }
                }
            
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
            
            Button("Get Weather") {
                Task {
                    await viewModel.fetchWeather()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
