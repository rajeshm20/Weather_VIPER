import SwiftUI

/// Base protocol for all VIPER Views
/// - Note: Views are passive and dumb, only display what presenter tells them
/// - Author: Senior iOS Technical Lead
protocol BaseViewProtocol: AnyObject {
    associatedtype PresenterType
    var presenter: PresenterType { get set }
}

/// Base protocol for all VIPER Presenters
/// - Note: Presenters contain presentation logic, no business logic
/// - Author: Senior iOS Technical Lead
protocol BasePresenterProtocol: AnyObject {
    associatedtype RouterType
    associatedtype InteractorType
    
    var router: RouterType { get }
    var interactor: InteractorType { get }
}

/// Base protocol for all VIPER Interactors
/// - Note: Interactors contain business logic and use cases
/// - Author: Senior iOS Technical Lead
protocol BaseInteractorProtocol: AnyObject {
    // Marker protocol - specific interactors define their own methods
}

/// Base protocol for all VIPER Routers
/// - Note: Routers handle navigation logic
/// - Author: Senior iOS Technical Lead
protocol BaseRouterProtocol: AnyObject {
    // Navigation methods defined per router
}

/// Router type for VIPER modules
/// - Note: Enables navigation through AppCoordinator
/// - Author: Senior iOS Technical Lead
enum RouterType {
    case push
    case present
    case replace
    case dismiss
}
