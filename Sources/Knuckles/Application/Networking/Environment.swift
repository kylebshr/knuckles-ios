import UIKit
import LinkKit

enum Environment {

    static var current: Environment = .local

    static let plaidPublicKey = "4b1cc9012fa80c462090c6e8880240"

    case production
    case local

    var baseURL: URL {
        switch self {
        case .production:
            return "https://knuckles-vapor.herokuapp.com"
        case .local:
            return "https://5bd1caaf18e4.ngrok.io"
        }
    }

    var plaidEnvironment: PLKEnvironment {
        switch self {
        case .production:
            return .development
        case .local:
            return .sandbox
        }
    }
}
