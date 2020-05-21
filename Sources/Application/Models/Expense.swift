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

    func nextAmountSaved(using period: PayPeriod, on date: Date = Date()) -> Decimal {
        let payDays = period.from(date: previousDueDate(from: date), to: nextDueDate(from: date))
        return amount / Decimal(payDays.count)
    }

    func amountSaved(using period: PayPeriod, on date: Date = Date()) -> Decimal {
        let date = calendar.date(byAdding: .day, value: 1, to: date)!
        let payDays = period.from(date: previousDueDate(from: date), to: date)
        return nextAmountSaved(using: period, on: date) * Decimal(payDays.count)
    }

    func nextDueDate(from date: Date) -> Date  {
        if calendar.component(.day, from: date) == dayDueAt { return date }
        let components = DateComponents(calendar: calendar, day: dayDueAt)
        return calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime)!
    }

    func previousDueDate(from date: Date) -> Date {
        let components = DateComponents(calendar: calendar, day: dayDueAt)
        return calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime, direction: .backward)!
    }
}
