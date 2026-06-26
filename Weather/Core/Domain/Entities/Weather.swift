import Foundation

/// Domain entity representing weather information
/// - Note: Pure domain model with no framework dependencies (SOLID - SRP)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
public struct Weather: Equatable, Identifiable {
    
    // MARK: - Properties
    
    /// Unique identifier for the weather record
    public let id: UUID
    
    /// City name
    public let cityName: String
    
    /// Country code (e.g., "US", "UK")
    public let countryCode: String
    
    /// Temperature in Celsius
    public let temperature: Double
    
    /// Feels like temperature in Celsius
    public let feelsLike: Double
    
    /// Minimum temperature in Celsius
    public let tempMin: Double
    
    /// Maximum temperature in Celsius
    public let tempMax: Double
    
    /// Atmospheric pressure in hPa
    public let pressure: Int
    
    /// Humidity percentage
    public let humidity: Int
    
    /// Weather condition description (e.g., "Clear sky")
    public let description: String
    
    /// Weather condition main category (e.g., "Clear", "Clouds")
    public let main: String
    
    /// Weather icon code
    public let icon: String
    
    /// Wind speed in meter/sec
    public let windSpeed: Double
    
    /// Cloud coverage percentage
    public let cloudiness: Int
    
    /// Timestamp when data was fetched
    public let timestamp: Date
    
    /// Indicates if data is from local storage (offline)
    public let isOffline: Bool
    
    /// Last sync timestamp with remote API
    public let lastSyncDate: Date?
    
    // MARK: - Initialization
    
    /// Initialize a Weather entity
    /// - Parameters:
    ///   - id: Unique identifier (generates UUID if not provided)
    ///   - cityName: Name of the city
    ///   - countryCode: Country code
    ///   - temperature: Current temperature in Celsius
    ///   - feelsLike: Perceived temperature
    ///   - tempMin: Minimum temperature
    ///   - tempMax: Maximum temperature
    ///   - pressure: Atmospheric pressure
    ///   - humidity: Humidity percentage
    ///   - description: Weather description
    ///   - main: Main weather category
    ///   - icon: Icon code
    ///   - windSpeed: Wind speed
    ///   - cloudiness: Cloud coverage
    ///   - timestamp: Data timestamp
    ///   - isOffline: Offline data flag
    ///   - lastSyncDate: Last sync timestamp
    public init(
        id: UUID = UUID(),
        cityName: String,
        countryCode: String,
        temperature: Double,
        feelsLike: Double,
        tempMin: Double,
        tempMax: Double,
        pressure: Int,
        humidity: Int,
        description: String,
        main: String,
        icon: String,
        windSpeed: Double,
        cloudiness: Int,
        timestamp: Date = Date(),
        isOffline: Bool = false,
        lastSyncDate: Date? = nil
    ) {
        self.id = id
        self.cityName = cityName
        self.countryCode = countryCode
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
        self.description = description
        self.main = main
        self.icon = icon
        self.windSpeed = windSpeed
        self.cloudiness = cloudiness
        self.timestamp = timestamp
        self.isOffline = isOffline
        self.lastSyncDate = lastSyncDate
    }
    
    // MARK: - Computed Properties
    
    /// Full location string (City, Country)
    public var fullLocation: String {
        "\(cityName), \(countryCode)"
    }
    
    /// Temperature formatted string
    public var temperatureFormatted: String {
        String(format: "%.1f°C", temperature)
    }
    
    /// Indicates if data is stale (older than 30 minutes)
    public var isStale: Bool {
        Date().timeIntervalSince(timestamp) > 1800 // 30 minutes
    }
}
