//
//  UIColor+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

extension UIColor {

    static let customBlue = UIColor(displayP3Red: 0.325, green: 0.596, blue: 1.000, alpha: 1)
    static let customPink = UIColor(displayP3Red: 0.967, green: 0.302, blue: 0.422, alpha: 1)

    static let inverseBackground = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return .black
        default: return .white
        }
    }

    static let inverseText = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return .white
        default: return .black
        }
    }
}
