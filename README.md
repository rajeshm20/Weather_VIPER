# Weather App - VIPER + Clean Architecture

A production-ready iOS weather application built with **VIPER architecture**, **Clean Architecture principles**, **SOLID design patterns**, **SwiftData** for local persistence, and **offline-first** architecture with remote API synchronization.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [SOLID Principles Implementation](#solid-principles-implementation)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Setup Instructions](#setup-instructions)
- [Architecture Details](#architecture-details)
- [Offline-First Pattern](#offline-first-pattern)
- [Testing Strategy](#testing-strategy)
- [API Documentation](#api-documentation)

---

## 🏗 Architecture Overview

This project implements a **three-layer Clean Architecture** combined with **VIPER pattern** for the presentation layer:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌────────────────────────────────────────────────────┐    │
│  │              VIPER MODULES                          │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │    │
│  │  │   View   │  │Presenter │  │Interactor│         │    │
│  │  └──────────┘  └──────────┘  └──────────┘         │    │
│  │  ┌──────────┐  ┌──────────┐                       │    │
│  │  │  Router  │  │  Entity  │                       │    │
│  │  └──────────┘  └──────────┘                       │    │
│  └────────────────────────────────────────────────────┘    │
│                    AppCoordinator                           │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌────────────┐  ┌────────────┐  ┌────────────────────┐   │
│  │  Entities  │  │ Use Cases  │  │Repository Protocols│   │
│  └────────────┘  └────────────┘  └────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐           │
│  │Repositories│  │   Mappers  │  │    DTOs    │           │
│  └────────────┘  └────────────┘  └────────────┘           │
│  ┌──────────────────────────────────────────────┐         │
│  │           Data Sources                        │         │
│  │  ┌──────────────┐  ┌──────────────┐         │         │
│  │  │    Remote    │  │    Local     │         │         │
│  │  │ (API Calls)  │  │ (SwiftData)  │         │         │
│  │  └──────────────┘  └──────────────┘         │         │
│  └──────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### 1. **Presentation Layer** (UI + VIPER)
- **View**: SwiftUI views (passive, only displays data)
- **Presenter**: Presentation logic, formats data for view
- **Interactor**: Business logic orchestration
- **Router**: Navigation logic
- **Entity**: View models (presentation entities)

#### 2. **Domain Layer** (Business Logic)
- **Entities**: Core business models (pure Swift, no dependencies)
- **Use Cases**: Single-responsibility business operations
- **Repository Protocols**: Abstractions for data access

#### 3. **Data Layer** (Data Management)
- **Repositories**: Implements repository protocols
- **Data Sources**: Remote (API) and Local (SwiftData)
- **DTOs**: Data Transfer Objects for API
- **Mappers**: Convert between layers

---

## 🎯 SOLID Principles Implementation

### ✅ Single Responsibility Principle (SRP)
Each class has ONE reason to change:
- **Use Cases**: Each handles one business operation
  - `GetWeatherUseCase` - Fetch weather only
  - `SyncWeatherUseCase` - Sync operation only
  - `ManageFavoriteCitiesUseCase` - Favorites management only

### ✅ Open/Closed Principle (OCP)
- Entities are **closed for modification**
- Use protocols to extend functionality
- New weather sources can be added by implementing `WeatherRepositoryProtocol`

### ✅ Liskov Substitution Principle (LSP)
- All implementations can replace their protocols
- `WeatherRepository` can be substituted with any `WeatherRepositoryProtocol`
- Mock implementations for testing

### ✅ Interface Segregation Principle (ISP)
- Separate protocols for different concerns:
  - `WeatherRepositoryProtocol` - Weather operations
  - `CityRepositoryProtocol` - City operations
  - Not one giant repository interface

### ✅ Dependency Inversion Principle (DIP)
- High-level modules depend on abstractions
- `WeatherListInteractor` depends on `WeatherRepositoryProtocol`, not concrete implementation
- Dependency Injection via constructors
- `DependencyContainer` manages all dependencies

---

## 📁 Project Structure

```
WeatherApp/
├── Core/
│   ├── Domain/                          # Business Logic Layer
│   │   ├── Entities/                    # Domain Models
│   │   │   ├── Weather.swift
│   │   │   └── City.swift
│   │   ├── UseCases/                    # Business Operations
│   │   │   ├── GetWeatherUseCase.swift
│   │   │   ├── GetSavedWeatherListUseCase.swift
│   │   │   ├── SyncWeatherUseCase.swift
│   │   │   └── ManageFavoriteCitiesUseCase.swift
│   │   └── RepositoryProtocols/         # Data Access Abstractions
│   │       └── WeatherRepositoryProtocol.swift
│   │
│   └── Data/                            # Data Layer
│       ├── Repositories/                # Repository Implementations
│       │   └── WeatherRepository.swift
│       ├── DataSources/
│       │   ├── Remote/                  # API Data Source
│       │   │   └── WeatherRemoteDataSource.swift
│       │   └── Local/                   # Local Storage (SwiftData)
│       │       ├── WeatherLocalDataSource.swift
│       │       └── WeatherDataModel.swift
│       ├── DTOs/                        # Data Transfer Objects
│       │   └── WeatherResponseDTO.swift
│       └── Mappers/                     # Layer Converters
│           └── WeatherMapper.swift
│
├── Presentation/                        # UI Layer
│   ├── Modules/                         # VIPER Modules
│   │   ├── WeatherList/
│   │   │   ├── WeatherListView.swift
│   │   │   ├── WeatherListPresenter.swift
│   │   │   ├── WeatherListInteractor.swift
│   │   │   ├── WeatherListRouter.swift
│   │   │   └── WeatherListModuleBuilder.swift
│   │   ├── WeatherDetail/
│   │   │   ├── WeatherDetailView.swift
│   │   │   ├── WeatherDetailPresenter.swift
│   │   │   ├── WeatherDetailInteractor.swift
│   │   │   ├── WeatherDetailRouter.swift
│   │   │   └── WeatherDetailModuleBuilder.swift
│   │   └── Settings/
│   │       ├── SettingsView.swift
│   │       ├── SettingsPresenter.swift
│   │       ├── SettingsInteractor.swift
│   │       ├── SettingsRouter.swift
│   │       └── SettingsModuleBuilder.swift
│   │
│   └── Common/
│       ├── AppCoordinator/              # Centralized Navigation
│       │   └── AppCoordinator.swift
│       ├── BaseVIPER/                   # VIPER Base Protocols
│       │   └── BaseVIPER.swift
│       └── DependencyContainer.swift    # Dependency Injection
│
├── Infrastructure/                      # Cross-cutting Concerns
│   ├── Network/                         # Networking
│   │   └── NetworkService.swift
│   └── Extensions/                      # Utilities
│       └── Extensions.swift
│
├── Resources/                           # App Resources
│   ├── Config/
│   └── Info.plist
│
├── WeatherApp.swift                     # App Entry Point
└── README.md
```

---

## 🛠 Technologies Used

- **Swift 5.9+**
- **SwiftUI** - Declarative UI framework
- **SwiftData** - Apple's data persistence framework
- **Async/Await** - Modern concurrency
- **Combine** - Reactive programming
- **URLSession** - Networking
- **OpenWeatherMap API** - Weather data provider

---

## 🚀 Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- OpenWeatherMap API Key

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd WeatherApp
   ```

2. **Get OpenWeatherMap API Key**
   - Visit [OpenWeatherMap](https://openweathermap.org/api)
   - Sign up for free account
   - Generate API key

3. **Configure API Key**
   - Open `Presentation/Common/DependencyContainer.swift`
   - Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```swift
   static let production = AppConfiguration(
       apiBaseURL: "https://api.openweathermap.org/data/2.5",
       apiKey: "YOUR_ACTUAL_API_KEY"
   )
   ```

4. **Open in Xcode**
   ```bash
   open WeatherApp.xcodeproj
   ```

5. **Build and Run**
   - Select target device/simulator
   - Press `Cmd + R` or click Run

---

## 🏛 Architecture Details

### VIPER Pattern Breakdown

#### **View**
- **Responsibility**: Display data, handle user interactions
- **Rules**: 
  - Passive and dumb
  - No business logic
  - Receives formatted data from Presenter
  - Sends user actions to Presenter

```swift
struct WeatherListView: View {
    @ObservedObject var presenter: WeatherListPresenter
    
    var body: some View {
        List(presenter.weatherList) { weather in
            // Display weather
        }
    }
}
```

#### **Interactor**
- **Responsibility**: Business logic, use case orchestration
- **Rules**:
  - Contains NO presentation logic
  - Communicates with Use Cases
  - Returns domain entities

```swift
final class WeatherListInteractor: BaseInteractorProtocol {
    private let getWeatherUseCase: GetWeatherUseCase
    
    func fetchWeather(for city: String) async throws -> Weather {
        try await getWeatherUseCase.execute(cityName: city)
    }
}
```

#### **Presenter**
- **Responsibility**: Presentation logic, data formatting
- **Rules**:
  - Formats data for View
  - Handles View events
  - Calls Interactor for business logic
  - Uses Router for navigation

```swift
final class WeatherListPresenter: ObservableObject {
    @Published var weatherList: [Weather] = []
    
    let router: WeatherListRouter
    let interactor: WeatherListInteractor
    
    func loadWeather() async {
        weatherList = try await interactor.fetchSavedWeather()
    }
}
```

#### **Entity**
- **Responsibility**: Data models for the module
- **Rules**:
  - Can be domain entities or view models
  - Immutable when possible

#### **Router**
- **Responsibility**: Navigation logic
- **Rules**:
  - Knows how to navigate to other modules
  - Works with AppCoordinator
  - Builds next modules

```swift
final class WeatherListRouter: BaseRouterProtocol {
    weak var coordinator: AppCoordinator?
    
    func navigateToDetail(weather: Weather) {
        coordinator?.navigate(to: .weatherDetail(weather))
    }
}
```

### AppCoordinator Pattern

Centralized navigation management:

```swift
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [Destination] = []
    
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    func build(for destination: Destination) -> some View {
        switch destination {
        case .weatherList:
            WeatherListModuleBuilder.build(...)
        case .weatherDetail(let weather):
            WeatherDetailModuleBuilder.build(weather: weather, ...)
        }
    }
}
```

**Benefits**:
- Single source of truth for navigation
- Deep linking support
- Testable navigation
- Easy to modify navigation flow

---

## 💾 Offline-First Pattern

The app implements a robust offline-first architecture:

### Strategy

```
User Request → Repository
                  ↓
       ┌──────────┴──────────┐
       ↓                     ↓
   Local Cache           Remote API
       ↓                     ↓
   Is Valid?              Success?
       ↓                     ↓
    Return ←── Yes ── Cache & Return
       ↓
    No → Fetch Remote
       ↓
   Update Cache
       ↓
    Return
```

### Implementation

```swift
func getWeather(for cityName: String) async throws -> Weather {
    // 1. Try local cache first
    if let cached = try await localDataSource.fetchWeather(for: cityName) {
        let weather = WeatherMapper.toDomain(from: cached)
        
        // 2. Check if cache is still valid (< 30 minutes)
        if !weather.isStale {
            return weather
        }
    }
    
    // 3. Fetch from remote API
    do {
        let dto = try await remoteDataSource.fetchWeather(for: cityName)
        let weather = WeatherMapper.toDomain(from: dto)
        
        // 4. Update local cache
        let model = WeatherMapper.toDataModel(from: weather)
        try await localDataSource.saveWeather(model)
        
        return weather
    } catch NetworkError.noInternetConnection {
        // 5. Return stale cache if offline
        if let cached = try await localDataSource.fetchWeather(for: cityName) {
            return WeatherMapper.toDomain(from: cached)
        }
        throw error
    }
}
```

### Background Sync

```swift
// Sync all saved cities in background
func syncAllWeather() async throws -> [Weather] {
    let savedWeather = try await getSavedWeatherList()
    var updated: [Weather] = []
    
    for weather in savedWeather {
        do {
            let fresh = try await getWeather(for: weather.cityName)
            updated.append(fresh)
        } catch {
            // Keep existing data on failure
            updated.append(weather)
        }
    }
    
    return updated
}
```

### SwiftData Integration

```swift
@Model
final class WeatherDataModel {
    @Attribute(.unique) var id: UUID
    var cityName: String
    var temperature: Double
    var timestamp: Date
    var lastSyncDate: Date?
    // ... other properties
}
```

**Benefits**:
- Works offline seamlessly
- Automatic cache management
- Background refresh capability
- Optimistic UI updates

---

## 🧪 Testing Strategy

### Unit Testing

Each layer can be tested independently:

```swift
// Mock Repository for testing Interactor
class MockWeatherRepository: WeatherRepositoryProtocol {
    var mockWeather: Weather?
    
    func getWeather(for cityName: String) async throws -> Weather {
        guard let weather = mockWeather else {
            throw TestError.noData
        }
        return weather
    }
}

// Test Interactor
func testFetchWeather() async throws {
    let mockRepo = MockWeatherRepository()
    mockRepo.mockWeather = Weather(/* ... */)
    
    let useCase = GetWeatherUseCase(weatherRepository: mockRepo)
    let interactor = WeatherListInteractor(getWeatherUseCase: useCase, /* ... */)
    
    let result = try await interactor.fetchWeather(for: "London")
    XCTAssertEqual(result.cityName, "London")
}
```

### Integration Testing

Test complete flows:

```swift
func testOfflineFirstPattern() async throws {
    // Setup
    let container = createTestContainer()
    let repository = WeatherRepository(/* ... */)
    
    // Test cache hit
    let weather1 = try await repository.getWeather(for: "London")
    XCTAssertFalse(weather1.isOffline)
    
    // Test offline mode
    disableNetwork()
    let weather2 = try await repository.getWeather(for: "London")
    XCTAssertTrue(weather2.isOffline)
}
```

### UI Testing

Test user flows:

```swift
func testWeatherListFlow() {
    let app = XCUIApplication()
    app.launch()
    
    // Add city
    app.buttons["Add City"].tap()
    app.textFields["Search"].typeText("London\n")
    app.buttons["London, GB"].tap()
    
    // Verify display
    XCTAssertTrue(app.staticTexts["London, GB"].exists)
}
```

---

## 📡 API Documentation

### OpenWeatherMap API

**Base URL**: `https://api.openweathermap.org/data/2.5`

#### Get Current Weather

```
GET /weather
Parameters:
  - q: City name (e.g., "London,GB")
  - appid: API key
  - units: metric (Celsius) or imperial (Fahrenheit)

Response:
{
  "name": "London",
  "main": {
    "temp": 15.5,
    "feels_like": 14.2,
    "temp_min": 13.0,
    "temp_max": 17.0,
    "pressure": 1013,
    "humidity": 72
  },
  "weather": [{
    "main": "Clouds",
    "description": "broken clouds",
    "icon": "04d"
  }],
  "wind": {
    "speed": 3.5
  },
  "clouds": {
    "all": 75
  }
}
```

#### Geocoding API

```
GET /geo/1.0/direct
Parameters:
  - q: City name query
  - limit: Number of results
  - appid: API key

Response:
[
  {
    "name": "London",
    "country": "GB",
    "lat": 51.5074,
    "lon": -0.1278
  }
]
```

---

## 🔑 Key Features

✅ **VIPER Architecture** - Complete separation of concerns  
✅ **Clean Architecture** - 3-layer architecture with clear boundaries  
✅ **SOLID Principles** - All 5 principles implemented  
✅ **SwiftData** - Modern data persistence  
✅ **Offline-First** - Works without internet  
✅ **Background Sync** - Automatic data refresh  
✅ **AppCoordinator** - Centralized navigation  
✅ **Dependency Injection** - Testable and maintainable  
✅ **Error Handling** - Comprehensive error management  
✅ **SwiftUI** - Modern declarative UI  
✅ **Async/Await** - Modern concurrency  

---

## 📝 Code Documentation

All code includes comprehensive documentation:
- File headers with author and version
- Method documentation with parameters and return values
- Architecture notes explaining design decisions
- SOLID principle annotations

Example:
```swift
/// Get weather with offline-first pattern
/// - Parameter cityName: City name
/// - Returns: Weather entity
/// - Note: Strategy - Try local cache first, fetch remote on miss or stale data
/// - Note: Follows SOLID - Dependency Inversion Principle
func getWeather(for cityName: String) async throws -> Weather {
    // Implementation
}
```

---

## 🎓 Learning Resources

### VIPER Architecture
- [VIPER Architecture in iOS](https://www.objc.io/issues/13-architecture/viper/)
- [iOS VIPER Architecture](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)

### Clean Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [iOS Clean Architecture](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)

### SOLID Principles
- [SOLID Principles in Swift](https://medium.com/swift-india/solid-principles-part-1-single-responsibility-principle-6bb8e3e4ff4)

---

## 👨‍💻 Author

**Senior iOS Technical Lead**

---

## 📄 License

This project is created for educational and demonstration purposes.

---

## 🙏 Acknowledgments

- OpenWeatherMap for providing the weather API
- Apple for SwiftUI and SwiftData frameworks
- Clean Architecture community
