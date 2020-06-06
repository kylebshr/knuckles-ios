//
//  String+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/6/20.
//

import Foundation

extension String {
    func droppingZeroes() -> String {
        if hasSuffix(".00") {
            return String(dropLast(3))
        } else {
            return self
        }
    }
}
