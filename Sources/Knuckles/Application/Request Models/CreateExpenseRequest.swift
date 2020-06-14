//
//  CreateExpenseRequest.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/12/20.
//

import Foundation

struct CreateExpenseRequest: Codable {
    var name: String
    var emoji: String
    var amount: Decimal
    var dayDueAt: Date
}
