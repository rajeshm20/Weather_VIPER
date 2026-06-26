import Foundation
import SwiftData

/// SwiftData model for persisting weather data
/// - Note: Data layer persistence model (separated from domain entity)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
@Model
final class WeatherDataModel {
    
    // MARK: - Properties
    
    @Attribute(.unique) var id: UUID
    var cityName: String
    var countryCode: String
    var temperature: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var pressure: Int
    var humidity: Int
    var weatherDescription: String
    var weatherMain: String
    var icon: String
    var windSpeed: Double
    var cloudiness: Int
    var timestamp: Date
    var lastSyncDate: Date?
    
    // MARK: - Relationships
    
    // Optional: Can add relationship to CityDataModel if needed
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        cityName: String,
        countryCode: String,
        temperature: Double,
        feelsLike: Double,
        tempMin: Double,
        tempMax: Double,
        pressure: Int,
        humidity: Int,
        weatherDescription: String,
        weatherMain: String,
        icon: String,
        windSpeed: Double,
        cloudiness: Int,
        timestamp: Date = Date(),
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
        self.weatherDescription = weatherDescription
        self.weatherMain = weatherMain
        self.icon = icon
        self.windSpeed = windSpeed
        self.cloudiness = cloudiness
        self.timestamp = timestamp
        self.lastSyncDate = lastSyncDate
    }
}

/// SwiftData model for persisting city data
@Model
final class CityDataModel {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var countryCode: String
    var latitude: Double
    var longitude: Double
    var isFavorite: Bool
    var favoriteOrder: Int?
    var dateAdded: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        countryCode: String,
        latitude: Double,
        longitude: Double,
        isFavorite: Bool = false,
        favoriteOrder: Int? = nil,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
        self.favoriteOrder = favoriteOrder
        self.dateAdded = dateAdded
    }
}
