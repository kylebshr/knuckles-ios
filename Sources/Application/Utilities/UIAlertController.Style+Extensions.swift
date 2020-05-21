//
//  UIAlertController.Style+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/29/20.
//

import UIKit

extension UIAlertController.Style {

    static var automaticSheet: UIAlertController.Style {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: return .alert
        default: return .actionSheet
        }
    }

}
