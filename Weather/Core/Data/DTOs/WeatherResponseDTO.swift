import Foundation

/// Data Transfer Object for OpenWeatherMap API response
/// - Note: Separates external API model from domain model (Clean Architecture)
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
/// - API: OpenWeatherMap Current Weather Data API
struct WeatherResponseDTO: Codable {
    let coord: Coordinates
    let weather: [WeatherInfo]
    let base: String
    let main: MainWeather
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: System
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    struct Coordinates: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct WeatherInfo: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int?
        let gust: Double?
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct System: Codable {
        let type: Int?
        let id: Int?
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}

/// DTO for city search/geocoding response
struct CityGeocodeDTO: Codable {
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat
        case lon
        case country
        case state
    }
}
