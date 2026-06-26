# Quick Start Guide - Weather App

## 🚀 For New Developers

### First Time Setup (5 minutes)

1. **Get API Key**
   ```
   1. Go to https://openweathermap.org/api
   2. Sign up (free)
   3. Navigate to API Keys section
   4. Copy your API key
   ```

2. **Configure Project**
   ```swift
   // Open: Presentation/Common/DependencyContainer.swift
   // Line ~75, replace:
   apiKey: "YOUR_API_KEY_HERE"
   // with your actual key:
   apiKey: "abc123yourkey"
   ```

3. **Run**
   ```
   Open WeatherApp.xcodeproj
   Select target: iPhone 15 Pro
   Press Cmd + R
   ```

---

## 📱 Using the App

### Add Your First City
1. Tap **+** button (top right)
2. Type city name (e.g., "London")
3. Select from search results
4. Weather appears automatically

### View Details
- Tap any city to see detailed weather
- Pull down to refresh
- Swipe left to delete

### Offline Mode
- App works without internet
- Shows "Offline" indicator when using cached data
- Auto-syncs when connection returns

---

## 🏗 Architecture Quick Reference

### Adding a New Feature

#### 1. Create Domain Entity (if needed)
```swift
// Core/Domain/Entities/YourEntity.swift
public struct YourEntity: Equatable, Identifiable {
    public let id: UUID
    public let name: String
}
```

#### 2. Create Use Case
```swift
// Core/Domain/UseCases/YourUseCase.swift
public final class YourUseCase {
    private let repository: YourRepositoryProtocol
    
    public init(repository: YourRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> YourEntity {
        try await repository.fetch()
    }
}
```

#### 3. Create VIPER Module

**File Structure:**
```
Presentation/Modules/YourFeature/
├── YourFeatureView.swift
├── YourFeaturePresenter.swift
├── YourFeatureInteractor.swift
├── YourFeatureRouter.swift
└── YourFeatureModuleBuilder.swift
```

**View** (SwiftUI):
```swift
struct YourFeatureView: View {
    @ObservedObject var presenter: YourFeaturePresenter
    
    var body: some View {
        // Your UI
    }
}
```

**Presenter**:
```swift
@MainActor
final class YourFeaturePresenter: ObservableObject {
    @Published var data: [YourEntity] = []
    
    let router: YourFeatureRouter
    let interactor: YourFeatureInteractor
    
    func loadData() async {
        data = try await interactor.fetchData()
    }
}
```

**Interactor**:
```swift
final class YourFeatureInteractor: BaseInteractorProtocol {
    private let useCase: YourUseCase
    
    init(useCase: YourUseCase) {
        self.useCase = useCase
    }
    
    func fetchData() async throws -> [YourEntity] {
        try await useCase.execute()
    }
}
```

**Router**:
```swift
final class YourFeatureRouter: BaseRouterProtocol {
    weak var coordinator: AppCoordinator?
    
    func navigateTo() {
        coordinator?.navigate(to: .yourDestination)
    }
}
```

**Builder**:
```swift
enum YourFeatureModuleBuilder {
    @MainActor
    static func build(
        coordinator: AppCoordinator,
        dependencyContainer: DependencyContainer
    ) -> YourFeatureView {
        let router = YourFeatureRouter(coordinator: coordinator)
        let interactor = YourFeatureInteractor(
            useCase: dependencyContainer.yourUseCase
        )
        let presenter = YourFeaturePresenter(
            router: router,
            interactor: interactor
        )
        return YourFeatureView(presenter: presenter)
    }
}
```

#### 4. Register in AppCoordinator

```swift
// Add to Destination enum
enum Destination: Hashable {
    case yourFeature(YourEntity)
}

// Add to build method
func build(for destination: Destination) -> some View {
    switch destination {
    case .yourFeature(let entity):
        buildYourFeatureModule(entity: entity)
    }
}

// Add builder method
private func buildYourFeatureModule(entity: YourEntity) -> some View {
    YourFeatureModuleBuilder.build(
        entity: entity,
        coordinator: self,
        dependencyContainer: dependencyContainer
    )
}
```

---

## 🧪 Testing Your Code

### Unit Test Template

```swift
import XCTest
@testable import WeatherApp

final class YourFeatureTests: XCTestCase {
    
    var sut: YourFeature!  // System Under Test
    var mockDependency: MockDependency!
    
    override func setUp() {
        super.setUp()
        mockDependency = MockDependency()
        sut = YourFeature(dependency: mockDependency)
    }
    
    override func tearDown() {
        sut = nil
        mockDependency = nil
        super.tearDown()
    }
    
    func testFeature_WithValidInput_ReturnsExpected() async throws {
        // Given
        let input = "test"
        let expected = "result"
        mockDependency.valueToReturn = expected
        
        // When
        let result = try await sut.execute(input)
        
        // Then
        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockDependency.callCount, 1)
    }
}
```

### Running Tests
```
Cmd + U (Run all tests)
Cmd + Ctrl + U (Run test under cursor)
```

---

## 🔍 Debugging Tips

### Common Issues

**1. API Key Error**
```
Error: 401 Unauthorized
Fix: Check API key in DependencyContainer.swift
```

**2. No Data Showing**
```
Check: 
- Internet connection
- API response in console
- SwiftData model container initialization
```

**3. Navigation Not Working**
```
Verify:
- Destination added to enum
- build() switch case added
- Coordinator passed to builder
```

### Debug Print Helpers

```swift
// Network requests
print("🌐 Fetching: \(url)")

// Repository cache
print("💾 Cache hit: \(cityName)")

// Navigation
print("🧭 Navigating to: \(destination)")
```

---

## 📊 Project Statistics

- **Total Files**: 40+
- **Lines of Code**: ~3000+
- **Modules**: 3 VIPER modules
- **Use Cases**: 4
- **Test Coverage**: Unit + Integration tests included

---

## 🎯 Code Quality Checklist

Before committing:
- [ ] All files have header documentation
- [ ] Public APIs have doc comments
- [ ] No force unwraps (!)
- [ ] Error handling implemented
- [ ] Unit tests written
- [ ] SOLID principles followed
- [ ] No direct dependencies between layers

---

## 📚 Learning Path

**Day 1-2**: Understand Clean Architecture
- Read `ARCHITECTURE.md`
- Review layer separation
- Understand dependency flow

**Day 3-4**: Master VIPER
- Study one module completely
- Understand each component's role
- Follow data flow

**Day 5**: Offline-First Pattern
- Review `WeatherRepository`
- Understand cache strategy
- Study sync mechanism

**Day 6**: Navigation
- Study `AppCoordinator`
- Understand routing
- Practice adding screens

**Week 2**: Build Your Feature
- Apply what you learned
- Follow the templates
- Ask for code review

---

## 🆘 Getting Help

1. **Check Documentation**
   - README.md - Overview
   - ARCHITECTURE.md - Design decisions
   - This file - Quick reference

2. **Search Codebase**
   ```
   Cmd + Shift + F (Find in project)
   ```

3. **Debug Mode**
   ```
   Add breakpoints
   Use `po` in console
   Check network requests
   ```

---

## ✅ Daily Development Workflow

```bash
# Morning
1. Pull latest code
2. Run tests (Cmd + U)
3. Check for compilation errors

# During Development
1. Write feature code
2. Write tests
3. Run tests
4. Commit small changes

# Before Push
1. Run all tests
2. Check code documentation
3. Verify SOLID principles
4. Push to feature branch
```

---

## 🎓 Best Practices

1. **Always inject dependencies**
   ```swift
   // ✅ Good
   init(repository: WeatherRepositoryProtocol)
   
   // ❌ Bad
   let repository = WeatherRepository()
   ```

2. **Keep Views dumb**
   ```swift
   // ✅ Good
   Text(presenter.formattedTemperature)
   
   // ❌ Bad
   Text("\(weather.temp)°C") // Formatting in view
   ```

3. **One responsibility per class**
   ```swift
   // ✅ Good
   GetWeatherUseCase - only fetches weather
   
   // ❌ Bad
   WeatherManager - fetches, caches, formats, navigates
   ```

4. **Protocol over concrete type**
   ```swift
   // ✅ Good
   let repo: WeatherRepositoryProtocol
   
   // ❌ Bad
   let repo: WeatherRepository
   ```

---

Happy Coding! 🚀
