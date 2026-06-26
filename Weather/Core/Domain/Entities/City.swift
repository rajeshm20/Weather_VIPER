import Foundation

/// Domain entity representing a city
/// - Note: Lightweight entity for city information (SOLID - SRP)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public struct City: Equatable, Identifiable {
    
    // MARK: - Properties
    
    /// Unique identifier
    public let id: UUID
    
    /// City name
    public let name: String
    
    /// Country code
    public let countryCode: String
    
    /// Latitude coordinate
    public let latitude: Double
    
    /// Longitude coordinate
    public let longitude: Double
    
    /// Indicates if city is marked as favorite
    public let isFavorite: Bool
    
    /// Order in favorites list
    public let favoriteOrder: Int?
    
    // MARK: - Initialization
    
    public init(
        id: UUID = UUID(),
        name: String,
        countryCode: String,
        latitude: Double,
        longitude: Double,
        isFavorite: Bool = false,
        favoriteOrder: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
        self.favoriteOrder = favoriteOrder
    }
    
    // MARK: - Computed Properties
    
    /// Full location string
    public var fullName: String {
        "\(name), \(countryCode)"
    }
}
