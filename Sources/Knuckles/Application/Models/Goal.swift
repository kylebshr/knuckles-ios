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

    init(emoji: Character, name: String, amount: Decimal, dayDueAt: Date) {
        self.emoji = "\(emoji)"
        self.name = name
        self.amount = amount
        self.dayDueAt = dayDueAt
        self.createdAt = calendar.startOfDay(for: Date())
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
        let payDays = period.from(date: createdAt, to: nextDay)
        return nextAmountSaved(using: period, on: date) * Decimal(payDays.count)
    }

    func isDue(on date: Date = Date()) -> Bool {
        calendar.isDate(date, inSameDayAs: dayDueAt)
    }

    func sortingDate(from date: Date = Date()) -> Date {
        if isDue(on: date) {
            return calendar.startOfDay(for: Date())
        } else {
            return dayDueAt
        }
    }
}
