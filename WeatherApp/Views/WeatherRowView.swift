import SwiftUI

struct WeatherRowView: View {
    var viewModel: WeatherDataProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: rowSpacing) {
            HStack {
                Text(viewModel.cityName)
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Text(viewModel.temperature)
                    .font(.largeTitle)
                    .bold()
            }
            .shadow(color: .gray, radius: shadowRadius)
            
            VStack(alignment: .leading) {
                Text(viewModel.weatherDescription)
                    .font(.title2)
                
                HStack {
                    Text(viewModel.humidity)
                        .font(.title3)
                    
                    Spacer()
                    
                    Text(viewModel.feelsLike)
                        .font(.title3)
                }
            }
        }
        .padding()
    }
    
//MARK: Private interface
private let shadowRadius: CGFloat = 2
private let rowSpacing: CGFloat = 20
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
    viewModel.weatherDescription = "Clear sky"
    viewModel.humidity = "Humidity: 78%"
    
    return viewModel
}
