import Foundation

/// Network error types
/// - Author: Senior iOS Technical Lead
enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noInternetConnection
    case timeout
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .noInternetConnection:
            return "No internet connection available"
        case .timeout:
            return "Request timeout"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

/// HTTP method enumeration
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Network service protocol
/// - Note: Follows SOLID - Interface Segregation Principle
/// - Author: Senior iOS Technical Lead
protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) async throws -> T
}

/// Concrete implementation of network service
/// - Note: Uses URLSession for networking
/// - Author: Senior iOS Technical Lead
final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    private let baseURL: String
    private let apiKey: String
    private let session: URLSession
    
    // MARK: - Initialization
    
    /// Initialize network service
    /// - Parameters:
    ///   - baseURL: Base API URL
    ///   - apiKey: API authentication key
    ///   - session: URLSession instance (injectable for testing)
    init(
        baseURL: String,
        apiKey: String,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
    }
    
    // MARK: - NetworkServiceProtocol
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil
    ) async throws -> T {
        
        // Build URL with query parameters
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        // Add API key and parameters
        var queryItems = [URLQueryItem(name: "appid", value: apiKey)]
        
        if let parameters = parameters {
            queryItems += parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Execute request
        do {
            let (data, response) = try await session.data(for: request)
            
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // Decode response
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch let urlError as URLError {
            if urlError.code == .notConnectedToInternet {
                throw NetworkError.noInternetConnection
            } else if urlError.code == .timedOut {
                throw NetworkError.timeout
            }
            throw NetworkError.unknown(urlError)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
