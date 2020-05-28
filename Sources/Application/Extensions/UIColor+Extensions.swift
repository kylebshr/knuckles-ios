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

    static let customBlack = UIColor(displayP3Red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
    static let customWhite = UIColor(displayP3Red: 0.989, green: 0.989, blue: 0.989, alpha: 1)

    static let customBlue = UIColor(displayP3Red: 0.325, green: 0.596, blue: 1.000, alpha: 1)
    static let customPink = UIColor(displayP3Red: 0.967, green: 0.302, blue: 0.422, alpha: 1)

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
}
