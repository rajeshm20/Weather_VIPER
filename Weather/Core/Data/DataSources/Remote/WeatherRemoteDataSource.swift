import Foundation

/// Protocol for remote weather data operations
/// - Note: Follows SOLID - Dependency Inversion Principle
/// - Author: Senior iOS Technical Lead
protocol WeatherRemoteDataSourceProtocol {
    func fetchWeather(for cityName: String) async throws -> WeatherResponseDTO
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponseDTO
    func searchCities(query: String) async throws -> [CityGeocodeDTO]
}

/// Remote data source implementation for OpenWeatherMap API
/// - Note: Handles all remote API interactions
/// - Author: Senior iOS Technical Lead
/// - API: OpenWeatherMap API v2.5
final class WeatherRemoteDataSource: WeatherRemoteDataSourceProtocol {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Endpoints
    
    private enum Endpoint {
        static let currentWeather = "/data/2.5/weather"
        static let geocoding = "/geo/1.0/direct"
    }
    
    // MARK: - Initialization
    
    /// Initialize with network service
    /// - Parameter networkService: Service for network requests
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - WeatherRemoteDataSourceProtocol
    
    /// Fetch weather data for city name
    /// - Parameter cityName: Name of the city
    /// - Returns: Weather response DTO
    /// - Throws: NetworkError
    func fetchWeather(for cityName: String) async throws -> WeatherResponseDTO {
        let parameters: [String: Any] = [
            "q": cityName,
            "units": "metric" // Celsius
        ]
        
        return try await networkService.request(
            endpoint: Endpoint.currentWeather,
            method: .get,
            parameters: parameters
        )
    }
    
    /// Fetch weather data for coordinates
    /// - Parameters:
    ///   - latitude: Latitude coordinate
    ///   - longitude: Longitude coordinate
    /// - Returns: Weather response DTO
    /// - Throws: NetworkError
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponseDTO {
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "units": "metric"
        ]
        
        return try await networkService.request(
            endpoint: Endpoint.currentWeather,
            method: .get,
            parameters: parameters
        )
    }
    
    /// Search cities by name using geocoding API
    /// - Parameter query: Search query
    /// - Returns: Array of city geocode DTOs
    /// - Throws: NetworkError
    func searchCities(query: String) async throws -> [CityGeocodeDTO] {
        let parameters: [String: Any] = [
            "q": query,
            "limit": 5
        ]
        
        return try await networkService.request(
            endpoint: Endpoint.geocoding,
            method: .get,
            parameters: parameters
        )
    }
}
