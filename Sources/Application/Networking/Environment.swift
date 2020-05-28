import UIKit

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
            return "https://82c372e2.ngrok.io"
        }
    }
}
