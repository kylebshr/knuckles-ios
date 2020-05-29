import Foundation

struct PlaidAccount: Codable {
    enum CodingKeys: String, CodingKey {
        case accountID = "accountId"
        case balances, name, type, subtype
    }

    enum AccountType: String, Codable {
        case depository
    }

    enum AccountSubtype: String, Codable {
        case checking
        case savings
    }

    var accountID: String
    var balances: PlaidBalance
    var name: String
    var type: AccountType
    var subtype: AccountSubtype
}
