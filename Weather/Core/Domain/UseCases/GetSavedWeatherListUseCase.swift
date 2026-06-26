import Foundation

/// Use case for fetching saved weather list
/// - Note: Follows SOLID - Single Responsibility Principle (SRP)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public final class GetSavedWeatherListUseCase {
    
    // MARK: - Properties
    
    private let weatherRepository: WeatherRepositoryProtocol
    
    // MARK: - Initialization
    
    public init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    // MARK: - Execution
    
    /// Execute use case to get all saved weather data
    /// - Returns: Array of saved weather records
    /// - Throws: Repository errors
    /// - Note: Returns offline cache for offline-first architecture
    public func execute() async throws -> [Weather] {
        try await weatherRepository.getSavedWeatherList()
    }
}
