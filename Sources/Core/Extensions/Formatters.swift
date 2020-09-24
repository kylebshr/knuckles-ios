//
//  NumberFormatter+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import Foundation

extension NumberFormatter {
    fileprivate static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.negativePrefix = "-"
        return formatter
    }()

    static let ordinal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()
}

extension DateFormatter {
    static let readyByFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    fileprivate static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}

extension Date {
    func day() -> String {
        return DateFormatter.dayFormatter.string(from: self)
    }
}

extension Decimal {

    private typealias Abbrevation = (threshold: Decimal, divisor: Decimal, suffix: String)

    func currency() -> String {
        let string = NumberFormatter.currency.string(from: self as NSNumber)!
        return string
    }

    func abbreviated() -> String {
        let numFormatter = NumberFormatter()

        let abbreviations: [Abbrevation] = [
            (0, 1, ""),
            (1000.0, 1000.0, "k"),
            (100_000.0, 1_000_000.0, "m"),
            (100_000_000.0, 1_000_000_000.0, "b"),
        ]
        let startValue = abs(self)
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }

                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = self / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.roundingMode = .down
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = abbreviation.suffix.isEmpty ? 0 : 1

        return numFormatter.string(from: value as NSNumber)!
    }
}
