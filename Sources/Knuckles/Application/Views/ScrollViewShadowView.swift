//
//  ScrollViewShadowView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/27/20.
//

import UIKit

class ScrollViewShadowView: UIView {

    private weak var scrollView: UIScrollView?
    private var observation: NSKeyValueObservation?

    private let borderLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.masksToBounds = false
        layer.addSublayer(borderLayer)
        borderLayer.opacity = 0
        borderLayer.borderWidth = .pixel

        backgroundColor = .customBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observation?.invalidate()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        borderLayer.borderColor = UIColor.separator.cgColor
        borderLayer.frame = layer.bounds.inset(by: .init(vertical: .pixel * -2, horizontal: .pixel * -2))

        if let scrollView = scrollView {
            update(using: scrollView)
        }
    }

    func observe(scrollView: UIScrollView?) {
        borderLayer.opacity = 0
        self.scrollView = scrollView
        observation = scrollView?.observe(\.contentOffset, options: [.new, .initial]) { [weak self] scrollView, _ in
            self?.update(using: scrollView)
        }
    }

    private func update(using scrollView: UIScrollView) {
        let offset: CGFloat = 20
        let intersection = scrollView.contentFrame(in: self).intersection(self.bounds).height.clamped(0, offset)
        let percentScrolled = intersection / offset

        borderLayer.opacity = Float(percentScrolled)
        backgroundColor = UIColor.customBackground.lerp(to: .elevatedBackground, amount: percentScrolled)
    }
}

private extension UIScrollView {
    func contentFrame(in view: UIView?) -> CGRect {
        var origin = convert(bounds.origin, to: view)
        origin.y -= contentOffset.y
        origin.x -= contentOffset.x
        return CGRect(origin: origin, size: contentSize)
    }
}

extension Comparable {
    func clamped(_ lower: Self, _ upper: Self) -> Self {
        return max(min(upper, self), lower)
    }
}
