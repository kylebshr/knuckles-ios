//
//  UIColor+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

extension UIColor {
    static let swizzleColors: Void = {
        for (original, replacement) in [
            (#selector(getter: UIColor.systemBackground), #selector(getter: UIColor.customBackground)),
            (#selector(getter: UIColor.label), #selector(getter: UIColor.customLabel)),
            ] {
                if let originalMethod = class_getClassMethod(UIColor.self, original),
                    let swizzledMethod = class_getClassMethod(UIColor.self, replacement)
                {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
        }
    }()
}

extension UIColor {

    static let customBlack = UIColor(displayP3Red: 0.083, green: 0.083, blue: 0.083, alpha: 1)
    static let customWhite = UIColor(displayP3Red: 0.989, green: 0.989, blue: 0.989, alpha: 1)

    static let customBlue = UIColor(displayP3Red: 0.325, green: 0.596, blue: 1.000, alpha: 1)
    static let customRed = UIColor(displayP3Red: 0.929, green: 0.333, blue: 0.333, alpha: 1)
    static let customPink = UIColor(displayP3Red: 1.000, green: 0.376, blue: 0.486, alpha: 1)
    static let customGreen = UIColor(displayP3Red: 0.410, green: 0.887, blue: 0.515, alpha: 1)

    static let shadow = UIColor(displayP3Red: 0.965, green: 0.965, blue: 0.965, alpha: 1)

    @objc private static let customLabel = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return .customBlack
        default: return .customWhite
        }
    }

    @objc private static let customBackground = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return .customWhite
        default: return .customBlack
        }
    }

    static let elevatedBackground = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return .customWhite
        default: return UIColor(displayP3Red: 0.123, green: 0.123, blue: 0.123, alpha: 1)
        }
    }

    func lerp(to: UIColor, amount: CGFloat) -> UIColor {
        let (r1, g1, b1, a1) = rgba
        let (r2, g2, b2, a2) = to.rgba
        return UIColor(displayP3Red: r1.lerp(to: r2, amount: amount),
                       green: g1.lerp(to: g2, amount: amount),
                       blue: b1.lerp(to: b2, amount: amount),
                       alpha: a1.lerp(to: a2, amount: amount))
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}
