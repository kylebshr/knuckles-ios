//
//  UIColor+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

extension UIColor {

    static let customBlack = UIColor(displayP3Red: 0.051, green: 0.075, blue: 0.129, alpha: 1)
    static let customWhite = UIColor(displayP3Red: 0.878, green: 0.976, blue: 0.953, alpha: 1)

    static let brand = UIColor(displayP3Red: 0.152, green: 0.368, blue: 0.871, alpha: 1)
    static let greenBackground = UIColor(displayP3Red: 0.878, green: 0.976, blue: 0.953, alpha: 1)
    static let bubbleBackground = UIColor(displayP3Red: 0.962, green: 0.962, blue: 0.962, alpha: 1)

    static let customBlue = UIColor(displayP3Red: 0.325, green: 0.596, blue: 1.000, alpha: 1)
    static let customRed = UIColor(displayP3Red: 1, green: 0.376, blue: 0.486, alpha: 1)
    static let customPink = UIColor(displayP3Red: 1.000, green: 0.376, blue: 0.486, alpha: 1)
    static let customGreen = UIColor(displayP3Red: 0.410, green: 0.887, blue: 0.515, alpha: 1)

    static let shadow = UIColor(displayP3Red: 0.965, green: 0.965, blue: 0.965, alpha: 1)

    static let customLabel = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return .customBlack
        default: return .customWhite
        }
    }

    static let customSecondaryLabel = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return UIColor(displayP3Red: 0.121, green: 0.164, blue: 0.262, alpha: 1)
        default: return .secondaryLabel
        }
    }

    static let customTertiaryLabel = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return UIColor(displayP3Red: 0.121, green: 0.164, blue: 0.262, alpha: 0.7)
        default: return .tertiaryLabel
        }
    }

    static let customBackground = UIColor { traits in
        switch traits.userInterfaceStyle {
        case .light: return .systemBackground // .customWhite
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
