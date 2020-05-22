//
//  Expense.swift
//  knuckles
//
//  Created by Kyle Bashour on 5/17/20.
//

import UIKit

private let calendar = Calendar(identifier: .gregorian)

struct Expense: Equatable {

    var name: String

    var amount: Decimal

    var tintColor: UIColor

    var dayDueAt: Int

    var createdAt: Date

    init(name: String, amount: Decimal, dayDueAt: Int) {
        self.name = name
        self.amount = amount
        self.dayDueAt = dayDueAt
        self.tintColor = [UIColor.systemBlue, .systemGreen, .systemRed, .systemYellow, .systemPurple, .systemPink, .systemTeal].randomElement()!
        self.createdAt = calendar.startOfDay(for: Date())
    }

    func isFunded(using period: PayPeriod) -> Bool {
        return amountSaved(using: period) == amount
    }

    func nextAmountSaved(using period: PayPeriod, on date: Date = Date()) -> Decimal {
        let payDays = period.from(date: previousDueDate(from: date), to: nextDueDate(from: date))
        return amount / Decimal(payDays.count)
    }

    func amountSaved(using period: PayPeriod, on date: Date = Date()) -> Decimal {
        let nextDay = calendar.date(byAdding: .day, value: 1, to: date)!
        let payDays = period.from(date: previousDueDate(from: date), to: nextDay)
        return nextAmountSaved(using: period, on: date) * Decimal(payDays.count)
    }

    func nextDueDate(from date: Date = Date()) -> Date  {
        let components = DateComponents(calendar: calendar, day: dayDueAt)
        return calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime)!
    }

    func previousDueDate(from date: Date = Date()) -> Date {
        if calendar.component(.day, from: date) == dayDueAt { return date }
        let components = DateComponents(calendar: calendar, day: dayDueAt)
        return calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime, direction: .backward)!
    }
}
