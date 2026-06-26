import Foundation
import Combine

/// Settings Presenter - VIPER Presenter component
/// - Author: Senior iOS Technical Lead
/// - Version: 1.0
@MainActor
final class SettingsPresenter: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var cachedCitiesCount: Int = 0
    @Published var isSyncing: Bool = false
    
    // MARK: - Dependencies
    
    let router: SettingsRouter
    let interactor: SettingsInteractor
    
    // MARK: - Computed Properties
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    // MARK: - Initialization
    
    init(router: SettingsRouter, interactor: SettingsInteractor) {
        self.router = router
        self.interactor = interactor
        
        Task {
            await loadCachedCount()
        }
    }
    
    // MARK: - Public Methods
    
    /// Load cached cities count
    func loadCachedCount() async {
        do {
            cachedCitiesCount = try await interactor.getCachedCitiesCount()
        } catch {
            print("Failed to load cached count: \(error)")
        }
    }
    
    /// Sync all weather data
    func syncAllData() async {
        isSyncing = true
        
        do {
            try await interactor.syncAllWeather()
            await loadCachedCount()
        } catch {
            print("Sync failed: \(error)")
        }
        
        isSyncing = false
    }
    
    /// Clear all cached data
    func clearCache() async {
        do {
            try await interactor.clearCache()
            cachedCitiesCount = 0
        } catch {
            print("Failed to clear cache: \(error)")
        }
    }
}
