import Foundation

/// Settings Interactor - VIPER Interactor component
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
final class SettingsInteractor: BaseInteractorProtocol {
    
    // MARK: - Dependencies
    
    private let weatherRepository: WeatherRepositoryProtocol
    private let syncWeatherUseCase: SyncWeatherUseCase
    
    // MARK: - Initialization
    
    init(
        weatherRepository: WeatherRepositoryProtocol,
        syncWeatherUseCase: SyncWeatherUseCase
    ) {
        self.weatherRepository = weatherRepository
        self.syncWeatherUseCase = syncWeatherUseCase
    }
    
    // MARK: - Business Logic
    
    /// Get count of cached cities
    /// - Returns: Number of cached weather records
    func getCachedCitiesCount() async throws -> Int {
        let weatherList = try await weatherRepository.getSavedWeatherList()
        return weatherList.count
    }
    
    /// Sync all weather data
    func syncAllWeather() async throws {
        _ = try await syncWeatherUseCase.execute()
    }
    
    /// Clear all cached data
    func clearCache() async throws {
        try await weatherRepository.clearCache()
    }
}
