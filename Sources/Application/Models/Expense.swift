//
//  Expense.swift
//  knuckles
//
//  Created by Kyle Bashour on 5/17/20.
//

import Foundation

private let calendar = Calendar(identifier: .gregorian)

struct Expense: Codable, Equatable {

    var name: String

    var amount: Decimal

    var dayDueAt: Int

    var createdAt: Date

    init(name: String, amount: Decimal, dayDueAt: Int) {
        self.name = name
        self.amount = amount
        self.dayDueAt = dayDueAt
        self.createdAt = calendar.startOfDay(for: Date())
    }

    func nextAmountSaved(using period: PayPeriod) -> Decimal {
        let payDays = period.from(date: previousDueDate, to: nextDueDate)
        return amount / Decimal(payDays.count)
    }

    func amountSaved(using period: PayPeriod) -> Decimal {
        let payDays = period.from(date: previousDueDate, to: Date())
        return nextAmountSaved(using: period) * Decimal(payDays.count)
    }

    var nextDueDate: Date {
        let components = DateComponents(calendar: calendar, day: dayDueAt)
        return calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)!
    }

    var previousDueDate: Date {
        let components = DateComponents(calendar: calendar, day: dayDueAt)
        return calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, direction: .backward)!
    }
}
