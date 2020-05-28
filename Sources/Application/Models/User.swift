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
