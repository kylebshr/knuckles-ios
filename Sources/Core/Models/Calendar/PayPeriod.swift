//
//  Calendar.swift
//  knuckles
//
//  Created by Kyle Bashour on 5/18/20.
//

import Foundation

private let calendar = Calendar(identifier: .gregorian)

enum PayPeriod {

    case weekly(day: Int)

    case biweekly(date: Date)

    case firstAndFifteenth(adjustForWeekends: Bool)

    case fifteenthAndLast(adjustForWeekends: Bool)

    case monthly(day: Int)

    case lastDayOfMonth

    func from(date from: Date, to: Date) -> [Date] {
        switch self {
        case .weekly(let day):
            return weeklyPeriods(from: from, to: to, on: day)
        case .firstAndFifteenth(let adjustForWeekends):
            return firstAndFifteenth(from: from, to: to, adjustForWeekends: adjustForWeekends)
        case .fifteenthAndLast(let adjustForWeekends):
            return fifteenthAndLast(from: from, to: to, adjustForWeekends: adjustForWeekends)
        default: fatalError()
        }
    }

    private func weeklyPeriods(from: Date, to: Date, on: Int) -> [Date] {
        let from = calendar.startOfDay(for: from)
        let to = calendar.startOfDay(for: to)

        let components = DateComponents(weekday: on)
        var date = calendar.component(.weekday, from: from) == on ? from
            : calendar.nextDate(after: from, matching: components, matchingPolicy: .nextTime)!
        var dates: [Date] = []

        while date < to || date == from {
            dates.append(date)
            date = calendar.date(byAdding: .weekOfYear, value: 1, to: date)!
        }

        return dates
    }

    private func firstAndFifteenth(from: Date, to: Date, adjustForWeekends: Bool) -> [Date] {
        let from = calendar.startOfDay(for: from)
        let to = calendar.startOfDay(for: to)

        var date = from
        var dates: [Date] = []

        if calendar.component(.day, from: from) == 15 || calendar.component(.day, from: from) == 1 {
            dates.append(from)
        }

        repeat {
            let day = calendar.component(.day, from: date)
            let components: DateComponents

            if day < 15 {
                components = DateComponents(day: 15)
            } else {
                components = DateComponents(day: 1)
            }

            date = calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime)!

            if adjustForWeekends, let weekendStart = calendar.dateIntervalOfWeekend(containing: date)?.start {
                let date = calendar.date(byAdding: .day, value: -1, to: weekendStart)!
                if date < to && date >= from {
                    dates.append(date)
                }
            } else if date < to {
                dates.append(date)
            }
        } while date < to

        return dates
    }

    private func fifteenthAndLast(from: Date, to: Date, adjustForWeekends: Bool) -> [Date] {
        let from = calendar.startOfDay(for: from)
        let to = calendar.startOfDay(for: to)

        var date: Date = Date()
        var dates: [Date] = []

        let day = calendar.component(.day, from: from)

        if day <= 15 {
            date = calendar.date(bySetting: .day, value: 15, of: from)!
        } else {
            date = from.endOfMonth()
        }

        while date < to || date == from {
            if adjustForWeekends, let weekendStart = calendar.dateIntervalOfWeekend(containing: date)?.start {
                let date = calendar.date(byAdding: .day, value: -1, to: weekendStart)!
                if date >= from {
                    dates.append(date)
                }
            } else {
                dates.append(date)
            }

            let day = calendar.component(.day, from: date)

            if day == 15 {
                date = date.endOfMonth()
            } else {
                date = calendar.date(bySetting: .day, value: 15, of: date.startOfMonth())!
                date = calendar.date(byAdding: .month, value: 1, to: date)!
            }
        }

        return dates
    }

}

extension Date {
    func startOfMonth() -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    func endOfMonth() -> Date {
        calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth())!
    }
}
