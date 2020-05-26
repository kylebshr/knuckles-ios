import UIKit

enum Environment {

    static var current: Environment = .local

    case production
    case local

    var baseURL: URL {
        switch self {
        case .production:
            return "https://knuckles-vapor.herokuapp.com"
        case .local:
            return "https://268d4eb0.ngrok.io"
        }
    }
}
