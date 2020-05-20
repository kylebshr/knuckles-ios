//
//  Expense.swift
//  knuckles
//
//  Created by Kyle Bashour on 5/17/20.
//

import Foundation

private let calendar = Calendar.autoupdatingCurrent

struct Expense: Codable, Equatable {

    var createdAt: Date

    var dayDueAt: Int

    var amount: Decimal

    var nextAmountSaved: Decimal {
        return 0
    }

    var amountSaved: Decimal {
        return 0
    }

    var nextDueDate: Date {
        let components = DateComponents(calendar: calendar, day: dayDueAt, hour: 0, minute: 0, second: 0)
        return calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)!
    }

}
