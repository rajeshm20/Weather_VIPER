import Foundation

/// WeatherDetail Interactor - VIPER Interactor component
/// - Note: Business logic for weather detail operations
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class WeatherDetailInteractor: BaseInteractorProtocol {
    
    // MARK: - Dependencies
    
    private let getWeatherUseCase: GetWeatherUseCase
    
    // MARK: - Initialization
    
    init(getWeatherUseCase: GetWeatherUseCase) {
        self.getWeatherUseCase = getWeatherUseCase
    }
    
    // MARK: - Business Logic
    
    /// Refresh weather data from API
    /// - Parameter cityName: City name
    /// - Returns: Updated weather
    func refreshWeather(for cityName: String) async throws -> Weather {
        try await getWeatherUseCase.execute(cityName: cityName)
    }
}
