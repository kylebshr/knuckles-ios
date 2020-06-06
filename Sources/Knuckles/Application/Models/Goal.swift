//
//  Expense.swift
//  knuckles
//
//  Created by Kyle Bashour on 5/17/20.
//

import Foundation

private let calendar = Calendar(identifier: .gregorian)

struct Goal: Codable, Equatable {

    var name: String

    var emoji: String

    var amount: Decimal

    var dayDueAt: Date

    var createdAt: Date

    init(emoji: Character,
         name: String,
         amount: Decimal,
         dayDueAt: Date,
         createdAt: Date = calendar.startOfDay(for: Date()))
    {
        self.emoji = "\(emoji)"
        self.name = name
        self.amount = amount
        self.dayDueAt = dayDueAt
        self.createdAt = createdAt
    }

    func isFunded(using period: PayPeriod) -> Bool {
        return amountSaved(using: period) == amount
    }

    func nextAmountSaved(using period: PayPeriod, on date: Date = Date()) -> Decimal {
        let payDays = period.from(date: createdAt, to: dayDueAt)
        return amount / Decimal(payDays.count)
    }

    func amountSaved(using period: PayPeriod, on date: Date = Date()) -> Decimal {
        let nextDay = calendar.date(byAdding: .day, value: 1, to: date)!
        let payDays = period.from(date: createdAt, to: min(nextDay, dayDueAt))
        return nextAmountSaved(using: period, on: date) * Decimal(payDays.count)
    }

    func sortingDate(from date: Date = Date()) -> Date {
        return dayDueAt
    }
}
