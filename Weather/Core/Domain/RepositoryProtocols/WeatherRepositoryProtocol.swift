import Foundation

/// Repository protocol for weather data operations
/// - Note: Follows SOLID - Dependency Inversion Principle (DIP)
/// - Note: Domain layer defines the contract, data layer implements it
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public protocol WeatherRepositoryProtocol {
    
    /// Fetch weather for a specific city
    /// - Parameter cityName: Name of the city
    /// - Returns: Weather data or error
    /// - Note: Implements offline-first pattern - tries local first, then remote
    func getWeather(for cityName: String) async throws -> Weather
    
    /// Fetch weather for coordinates
    /// - Parameters:
    ///   - latitude: Latitude coordinate
    ///   - longitude: Longitude coordinate
    /// - Returns: Weather data or error
    func getWeather(latitude: Double, longitude: Double) async throws -> Weather
    
    /// Get all saved weather data (offline cache)
    /// - Returns: Array of cached weather data
    func getSavedWeatherList() async throws -> [Weather]
    
    /// Save weather data locally
    /// - Parameter weather: Weather entity to save
    func saveWeather(_ weather: Weather) async throws
    
    /// Delete saved weather data
    /// - Parameter id: Weather record ID
    func deleteWeather(id: UUID) async throws
    
    /// Sync all saved cities with remote API
    /// - Returns: Array of updated weather data
    /// - Note: Background sync operation for offline-first architecture
    func syncAllWeather() async throws -> [Weather]
    
    /// Clear all local weather cache
    func clearCache() async throws
}

/// Repository protocol for city operations
/// - Note: Follows Interface Segregation Principle (ISP)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public protocol CityRepositoryProtocol {
    
    /// Search cities by name
    /// - Parameter query: Search query string
    /// - Returns: Array of matching cities
    func searchCities(query: String) async throws -> [City]
    
    /// Get all favorite cities
    /// - Returns: Array of favorite cities ordered by favoriteOrder
    func getFavoriteCities() async throws -> [City]
    
    /// Add city to favorites
    /// - Parameter city: City to add
    func addToFavorites(_ city: City) async throws
    
    /// Remove city from favorites
    /// - Parameter id: City ID to remove
    func removeFromFavorites(id: UUID) async throws
    
    /// Reorder favorite cities
    /// - Parameter cities: Ordered array of cities
    func reorderFavorites(_ cities: [City]) async throws
}
