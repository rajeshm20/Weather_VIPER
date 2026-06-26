import Foundation

/// Use case for fetching weather data
/// - Note: Follows SOLID - Single Responsibility Principle (SRP)
/// - Note: Each use case handles one specific business operation
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public final class GetWeatherUseCase {
    
    // MARK: - Properties
    
    private let weatherRepository: WeatherRepositoryProtocol
    
    // MARK: - Initialization
    
    /// Initialize with weather repository
    /// - Parameter weatherRepository: Repository for weather data
    /// - Note: Dependency Injection via constructor (DIP)
    public init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    // MARK: - Execution
    
    /// Execute use case to get weather for city
    /// - Parameter cityName: Name of the city
    /// - Returns: Weather data
    /// - Throws: Repository errors
    /// - Note: Implements offline-first pattern through repository
    public func execute(cityName: String) async throws -> Weather {
        try await weatherRepository.getWeather(for: cityName)
    }
    
    /// Execute use case to get weather for coordinates
    /// - Parameters:
    ///   - latitude: Latitude coordinate
    ///   - longitude: Longitude coordinate
    /// - Returns: Weather data
    /// - Throws: Repository errors
    public func execute(latitude: Double, longitude: Double) async throws -> Weather {
        try await weatherRepository.getWeather(latitude: latitude, longitude: longitude)
    }
}
