//
//  Date+Testing.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import Foundation

extension Date: ExpressibleByStringLiteral {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    public init(stringLiteral: String) {
        self = Date.formatter.date(from: stringLiteral)!
    }
}
