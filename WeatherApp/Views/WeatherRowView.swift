import SwiftUI

struct WeatherRowView: View {
    var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.cityName)
                .font(.title)
                .bold()
            
            Text(viewModel.temperature)
                .font(.title2)
            
            Text(viewModel.description)
                .font(.body)
            
            HStack {
                Text(viewModel.humidity)
                    .font(.subheadline)
                
                Spacer()
                
                Text(viewModel.feelsLike)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.8))
                        .shadow(radius: 5))
        .padding(.bottom, 10)
    }
}

#Preview {
    WeatherRowView(viewModel: previewViewModel)
}

@MainActor
var previewViewModel: WeatherViewModel {
    let mockWeather = WeatherModel(
        name: "Toronto",
        main: WeatherModel.Main(temp: 10.0, feelsLike: 8.0, humidity: 78),
        weather: [WeatherModel.Weather(main: "Clear", description: "clear sky", icon: "01d")]
    )
    
    let mockData = try! JSONEncoder().encode(mockWeather)
    let mockResponse = HTTPURLResponse(url: URL(string: "https://api.weather.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
    
    let mockService = MockURLSession(mockData: mockData, mockResponse: mockResponse)
    let viewModel = WeatherViewModel(networkService: mockService)
    
    viewModel.cityName = "Toronto"
    viewModel.temperature = "10°C"
    viewModel.feelsLike = "Feels like: 8°C"
    viewModel.description = "Clear sky"
    viewModel.humidity = "Humidity: 78%"
    
    return viewModel
}
