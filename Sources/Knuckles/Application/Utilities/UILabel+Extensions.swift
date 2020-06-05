//
//  UILabel+Extensions.swift
//  cam
//
//  Created by Kyle Bashour on 11/23/19.
//

import UIKit

extension UILabel {

    convenience init(font: UIFont, color: UIColor = .label, alignment: NSTextAlignment = .natural) {
        self.init(frame: .zero)
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }

}
