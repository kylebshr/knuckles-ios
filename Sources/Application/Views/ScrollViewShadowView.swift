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

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observation?.invalidate()
    }

    func observe(scrollView: UIScrollView) {
        self.scrollView = scrollView
        observation = scrollView.observe(\.contentOffset, options: [.new, .initial]) { [weak self] scrollView, _ in
            self?.update(using: scrollView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let scrollView = scrollView {
            update(using: scrollView)
        }
    }

    private func update(using scrollView: UIScrollView) {
        let offset: CGFloat = 20
        let intersection = scrollView.contentFrame(in: self).intersection(self.bounds).height.clamped(0, offset)
        let alpha = (intersection / offset) * 0.18
        layer.shadowOpacity = Float(alpha)
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
