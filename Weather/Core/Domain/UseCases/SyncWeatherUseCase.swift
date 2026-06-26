import Foundation

/// Use case for syncing weather data with remote API
/// - Note: Follows SOLID - Single Responsibility Principle (SRP)
/// - Note: Handles background sync for offline-first architecture
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public final class SyncWeatherUseCase {
    
    // MARK: - Properties
    
    private let weatherRepository: WeatherRepositoryProtocol
    
    // MARK: - Initialization
    
    public init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    // MARK: - Execution
    
    /// Execute sync operation for all saved cities
    /// - Returns: Updated weather data
    /// - Throws: Repository errors
    /// - Note: Can be called on app foreground or background refresh
    public func execute() async throws -> [Weather] {
        try await weatherRepository.syncAllWeather()
    }
}
