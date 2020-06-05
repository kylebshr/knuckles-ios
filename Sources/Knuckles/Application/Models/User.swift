//
//  User.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/26/20.
//

import Foundation

@objc class User: NSObject, Codable {
    var name: String
    var plaidAccessToken: String?
    var plaidItemID: String?
}

@objc class PlaidAccount: NSObject, Codable {
    var id: String

    var name: String
    var type: String
    var subtype: String
    var currentBalance: Decimal
    var availableBalance: Decimal?
    var currencyCode: String

    var createdAt: Date?
}

extension User {
    var hasCompletedPlaidLink: Bool {
        return plaidAccessToken != nil
    }
}
