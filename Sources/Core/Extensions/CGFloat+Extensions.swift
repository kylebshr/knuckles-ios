//
//  CGFloat+Extensions.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/28/20.
//

import UIKit

extension CGFloat {
    func lerp(to: CGFloat, amount: CGFloat) -> CGFloat {
        (1 - amount) * self + amount * to
    }

    static var pixel: CGFloat { 1 / UIScreen.main.scale }
}
