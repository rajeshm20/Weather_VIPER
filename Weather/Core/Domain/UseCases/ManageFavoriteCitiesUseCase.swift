import Foundation

/// Use case for managing favorite cities
/// - Note: Follows SOLID - Single Responsibility Principle (SRP)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public final class ManageFavoriteCitiesUseCase {
    
    // MARK: - Properties
    
    private let cityRepository: CityRepositoryProtocol
    
    // MARK: - Initialization
    
    public init(cityRepository: CityRepositoryProtocol) {
        self.cityRepository = cityRepository
    }
    
    // MARK: - Execution Methods
    
    /// Get all favorite cities
    /// - Returns: Ordered array of favorite cities
    public func getFavorites() async throws -> [City] {
        try await cityRepository.getFavoriteCities()
    }
    
    /// Add city to favorites
    /// - Parameter city: City to add
    public func addToFavorites(_ city: City) async throws {
        try await cityRepository.addToFavorites(city)
    }
    
    /// Remove city from favorites
    /// - Parameter id: City ID to remove
    public func removeFromFavorites(id: UUID) async throws {
        try await cityRepository.removeFromFavorites(id: id)
    }
    
    /// Reorder favorite cities
    /// - Parameter cities: New order of cities
    public func reorderFavorites(_ cities: [City]) async throws {
        try await cityRepository.reorderFavorites(cities)
    }
}
