import Foundation
import UIKit

struct SignUpRequest: Codable {
    var name: String
}

struct LoginController {

    static let shared = LoginController(environment: .current)

    enum LoginResult {
        case success(User)
        case noAccountFound
        case failed(Error?)
    }

    enum SignUpResult {
        case success(UserToken)
        case failed(Error?)
    }

    private let environment: Environment

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(environment: Environment) {
        self.environment = environment
    }

    func attemptLogin(identity: Data, completion: @escaping (LoginResult) -> Void) {
        let authorization = String(data: identity, encoding: .utf8)!
        var request = URLRequest(url: environment.baseURL.appendingPathComponent("login/apple"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [decoder] data, response, error in
            let response = response as? HTTPURLResponse
            DispatchQueue.main.async {
                if response?.statusCode == 401 {
                    completion(.noAccountFound)
                } else if let error = error {
                    completion(.failed(error))
                } else if let data = data, let token = try? decoder.decode(UserToken.self, from: data) {
                    UserDefaults.shared.login(token: token)
                    completion(.success(token.user))
                } else {
                    completion(.failed(nil))
                }
            }
        }.resume()
    }

    func signUp(identity: Data, meta: SignUpRequest, completion: @escaping (LoginResult) -> Void) {
        let authorization = String(data: identity, encoding: .utf8)!
        var request = URLRequest(url: environment.baseURL.appendingPathComponent("signup/apple"))
        request.httpBody = try? encoder.encode(meta)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authorization)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [decoder] data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failed(error))
                } else if let data = data, let token = try? decoder.decode(UserToken.self, from: data) {
                    UserDefaults.shared.login(token: token)
                    completion(.success(token.user))
                } else {
                    completion(.failed(nil))
                }
            }
        }.resume()
    }
}
