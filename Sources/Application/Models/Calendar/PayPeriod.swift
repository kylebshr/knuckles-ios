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

    case fifteenthAndLast

    case monthly(day: Int)

    case lastDayOfMonth

    func from(date from: Date, to: Date) -> [Date] {
        switch self {
        case .weekly(let day):
            return weeklyPeriods(from: from, to: to, on: day)
        case .firstAndFifteenth(let adjustForWeekends):
            return firstAndFifteenth(from: from, to: to, adjustForWeekends: adjustForWeekends)
        default: return []
        }
    }

    private func weeklyPeriods(from: Date, to: Date, on: Int) -> [Date] {
        let components = DateComponents(weekday: on)
        var date = calendar.nextDate(after: from, matching: components, matchingPolicy: .nextTime)!
        var dates: [Date] = []

        while date <= to {
            dates.append(date)
            date = calendar.date(byAdding: .weekOfYear, value: 1, to: date)!
        }

        return dates
    }

    private func firstAndFifteenth(from: Date, to: Date, adjustForWeekends: Bool) -> [Date] {
        var date = from
        var dates: [Date] = []

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
                if date <= to && date > from {
                    dates.append(date)
                }
            } else if date <= to && date > from {
                dates.append(date)
            }
        } while date <= to

        return dates
    }
}
