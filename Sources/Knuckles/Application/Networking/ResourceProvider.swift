import AuthenticationServices
import Foundation

private extension Environment {
    var components: URLComponents {
        var components = URLComponents()
        components.host = baseURL.host
        components.scheme = baseURL.scheme
        components.port = baseURL.port
        return components
    }
}

typealias Res<T> = Result<T, Error>

/// Provides loading of a Codable type from a given URL.
struct ResourceProvider {

    static let shared = ResourceProvider(environment: .current)

    enum ResourceProviderError: Error {
        case unknown
        case failedToCreateURL
        case httpError(Int)
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private let environment: Environment

    init(environment: Environment) {
        self.environment = environment
    }

    func authenticate(request: URLRequest, completion: @escaping (URLRequest) -> Void) {
        guard let authenticationToken = UserDefaults.standard.authenticationToken else {
            return completion(request)
        }

        var request = request
        request.setValue("Bearer \(authenticationToken)", forHTTPHeaderField: "Authorization")
        completion(request)
    }

    private func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        authenticate(request: request) { request in
            URLSession.shared.dataTask(with: request) { data, response, error in
                let response = response as? HTTPURLResponse
                DispatchQueue.main.async {
                    if response?.statusCode == 401 {
                        UserDefaults.standard.logout()
                    } else {
                        completion(data, response, error)
                    }
                }
            }.resume()
        }
    }

    /// Fetch and decode the resource at the URL from the initializer.
    ///
    /// - Parameter completion: This block will be called with the result of performing the network request.
    func fetchResource<T: Decodable>(at path: String, parameters: [String: Any] = [:], completion: @escaping (Result<T, Error>) -> Void) {

        var components = environment.components
        components.path = "/\(path)"
        components.queryItems = parameters.map { key, value in URLQueryItem(name: key, value: String(describing: value)) }

        guard let url = components.url else {
            return completion(.failure(ResourceProviderError.failedToCreateURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        perform(request: request) { [decoder] data, _, error in
            guard let data = data else {
                let error = error ?? ResourceProviderError.unknown
                completion(.failure(error))
                return
            }

            do {
                let resource = try decoder.decode(T.self, from: data)
                completion(.success(resource))
            } catch {
                completion(.failure(error))
            }

        }
    }

    func deleteResource(withID id: String, at path: String, completion: @escaping (Result<Void, Error>) -> Void) {

        var request = URLRequest(url: environment.baseURL
            .appendingPathComponent(path)
            .appendingPathComponent(id))
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        perform(request: request) { _, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(ResourceProviderError.unknown))
                return
            }

            switch response.statusCode {
            case 200..<300: completion(.success(()))
            default: completion(.failure(ResourceProviderError.httpError(response.statusCode)))
            }
        }
    }

    func createResource<T: Codable, U: Codable>(_ resource: T, at path: String, completion: @escaping (Result<U, Error>) -> Void) {

        var request = URLRequest(url: environment.baseURL.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try encoder.encode(resource)
        } catch {
            return completion(.failure(error))
        }

        perform(request: request) { [decoder] data, _, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                completion(.failure(ResourceProviderError.unknown))
                return
            }

            do {
                let resource = try decoder.decode(U.self, from: data)
                completion(.success(resource))
            } catch {
                completion(.failure(error))
            }
        }
    }

}
