//
//  RetroButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/6/20.
//

import UIKit

class RetroButton: Control {

    enum Style {
        case primary
        case secondary
    }

    private let down = UIImpactFeedbackGenerator(style: .heavy)
    private let up = UIImpactFeedbackGenerator(style: .rigid)

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 58)
    }

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    private let label = UILabel(font: .rubik(ofSize: 18, weight: .medium), alignment: .center)
    private lazy var retroView = RetroView(content: label, borderWidth: 3, offset: 7)

    init(text: String, color: UIColor, style: Style = .secondary) {
        super.init(frame: .zero)

        label.text = text

        switch style {
        case .primary:
            retroView.foreground = color
            retroView.background = .systemBackground
            label.textColor = .systemBackground
        case .secondary:
            retroView.foreground = .systemBackground
            retroView.background = color
            label.textColor = .label
        }

        addSubview(retroView)
        retroView.pinEdges(to: self)
    }

    override func updateState() {
        retroView.borderView.transform = isHighlighted ?
            CGAffineTransform(translationX: retroView.offset, y: retroView.offset) :
            .identity
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let beginTracking = super.beginTracking(touch, with: event)
        if beginTracking { down.impactOccurred() }
        return beginTracking
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        up.impactOccurred()
        super.endTracking(touch, with: event)
    }
}
