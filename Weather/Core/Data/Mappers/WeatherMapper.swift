import Foundation

/// Mapper for converting between DTO, DataModel, and Domain Entity
/// - Note: Follows SOLID - Single Responsibility Principle
/// - Note: Separates concerns between layers (Clean Architecture)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
enum WeatherMapper {
    
    // MARK: - DTO to Domain Entity
    
    /// Maps API response DTO to domain Weather entity
    /// - Parameter dto: WeatherResponseDTO from API
    /// - Returns: Weather domain entity
    static func toDomain(from dto: WeatherResponseDTO) -> Weather {
        let weatherInfo = dto.weather.first ?? WeatherResponseDTO.WeatherInfo(
            id: 0,
            main: "Unknown",
            description: "No description",
            icon: "01d"
        )
        
        return Weather(
            cityName: dto.name,
            countryCode: dto.sys.country,
            temperature: dto.main.temp,
            feelsLike: dto.main.feelsLike,
            tempMin: dto.main.tempMin,
            tempMax: dto.main.tempMax,
            pressure: dto.main.pressure,
            humidity: dto.main.humidity,
            description: weatherInfo.description,
            main: weatherInfo.main,
            icon: weatherInfo.icon,
            windSpeed: dto.wind.speed,
            cloudiness: dto.clouds.all,
            timestamp: Date(),
            isOffline: false,
            lastSyncDate: Date()
        )
    }
    
    // MARK: - DataModel to Domain Entity
    
    /// Maps SwiftData model to domain entity
    /// - Parameter model: WeatherDataModel from local storage
    /// - Returns: Weather domain entity
    static func toDomain(from model: WeatherDataModel) -> Weather {
        Weather(
            id: model.id,
            cityName: model.cityName,
            countryCode: model.countryCode,
            temperature: model.temperature,
            feelsLike: model.feelsLike,
            tempMin: model.tempMin,
            tempMax: model.tempMax,
            pressure: model.pressure,
            humidity: model.humidity,
            description: model.weatherDescription,
            main: model.weatherMain,
            icon: model.icon,
            windSpeed: model.windSpeed,
            cloudiness: model.cloudiness,
            timestamp: model.timestamp,
            isOffline: true,
            lastSyncDate: model.lastSyncDate
        )
    }
    
    // MARK: - Domain Entity to DataModel
    
    /// Maps domain entity to SwiftData model
    /// - Parameter weather: Weather domain entity
    /// - Returns: WeatherDataModel for persistence
    static func toDataModel(from weather: Weather) -> WeatherDataModel {
        WeatherDataModel(
            id: weather.id,
            cityName: weather.cityName,
            countryCode: weather.countryCode,
            temperature: weather.temperature,
            feelsLike: weather.feelsLike,
            tempMin: weather.tempMin,
            tempMax: weather.tempMax,
            pressure: weather.pressure,
            humidity: weather.humidity,
            weatherDescription: weather.description,
            weatherMain: weather.main,
            icon: weather.icon,
            windSpeed: weather.windSpeed,
            cloudiness: weather.cloudiness,
            timestamp: weather.timestamp,
            lastSyncDate: weather.lastSyncDate
        )
    }
}

/// Mapper for City entity conversions
enum CityMapper {
    
    // MARK: - DTO to Domain Entity
    
    static func toDomain(from dto: CityGeocodeDTO) -> City {
        City(
            name: dto.name,
            countryCode: dto.country,
            latitude: dto.lat,
            longitude: dto.lon
        )
    }
    
    // MARK: - DataModel to Domain Entity
    
    static func toDomain(from model: CityDataModel) -> City {
        City(
            id: model.id,
            name: model.name,
            countryCode: model.countryCode,
            latitude: model.latitude,
            longitude: model.longitude,
            isFavorite: model.isFavorite,
            favoriteOrder: model.favoriteOrder
        )
    }
    
    // MARK: - Domain Entity to DataModel
    
    static func toDataModel(from city: City) -> CityDataModel {
        CityDataModel(
            id: city.id,
            name: city.name,
            countryCode: city.countryCode,
            latitude: city.latitude,
            longitude: city.longitude,
            isFavorite: city.isFavorite,
            favoriteOrder: city.favoriteOrder
        )
    }
}
