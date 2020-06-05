//
//  PrivateWindow.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/1/20.
//

import UIKit

class PrivateWindow: UIWindow {

    private let blur = UIVisualEffectView(effect: nil)

    private var observers: [NSObjectProtocol] = []

    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)

        NotificationCenter.default.addObserver(self, selector: #selector(showBlur), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBlur), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func showBlur() {
        addSubview(blur)
        blur.effect = nil
        UIViewPropertyAnimator {
            self.blur.effect = UIBlurEffect(style: .systemThickMaterial)
        }.startAnimation()
    }

    @objc private func removeBlur() {
        let animation = UIViewPropertyAnimator {
            self.blur.effect = nil
        }

        animation.addCompletion { state in
            if state == .end {
                self.blur.removeFromSuperview()
            }
        }

        animation.startAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
    }
}
