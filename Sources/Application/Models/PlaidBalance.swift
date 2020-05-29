import Foundation

struct PlaidBalance: Codable {
    var current: Decimal
    var available: Decimal
    var isoCurrencyCode: String
}
