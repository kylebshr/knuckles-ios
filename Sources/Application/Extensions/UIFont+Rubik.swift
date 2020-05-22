//
//  UIFont+Rubik.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

//swiftlint:disable trailing_comma

import UIKit

extension UIFont {

    enum RubikWeight {
        case regular
        case medium
        case bold
        case black

        fileprivate var name: String {
            switch self {
            case .regular: return "Rubik-Regular"
            case .bold: return "Rubik-Bold"
            case .medium: return "Rubik-Medium"
            case .black: return "Rubik-Black"
            }
        }
    }

    static func rubik(ofSize size: CGFloat, weight: RubikWeight) -> UIFont {
        return UIFont(name: weight.name, size: size)!
    }

    static func monospacedRubik(ofSize size: CGFloat, weight: RubikWeight) -> UIFont {
        let descriptor = rubik(ofSize: size, weight: weight).fontDescriptor
        let monoDescriptor = descriptor.addingAttributes([.featureSettings: [[
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector,
            ]]])

        return UIFont(descriptor: monoDescriptor, size: size)
    }
}
