//
//  BubbleCell.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/24/20.
//

import UIKit

class GroupedBubbleCell: BubbleCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        bubbleView.layer.cornerRadius = 0
    }
}

class BubbleCell: UICollectionViewCell {
    fileprivate let bubbleView = UIView()

    let titleLabel = UILabel(font: .systemFont(ofSize: 18, weight: .medium), color: .customLabel)
    let subtitleLabel = UILabel(font: .systemFont(ofSize: 14, weight: .medium), color: .customSecondaryLabel)
    let detailLabel = UILabel(font: .systemFont(ofSize: 16, weight: .medium), color: .customSecondaryLabel)

    override var isSelected: Bool {
        didSet { updateHighlight() }
    }

    override var isHighlighted: Bool {
        didSet { updateHighlight() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bubbleView)
        bubbleView.pinEdges(to: contentView)
        bubbleView.backgroundColor = .bubbleBackground
        bubbleView.layer.cornerRadius = 12
        bubbleView.layer.cornerCurve = .continuous
        bubbleView.layoutMargins = .init(vertical: 10, horizontal: 15)
        bubbleView.heightAnchor.pin(greaterThan: 58)
        bubbleView.heightAnchor.pin(to: 58, priority: .fittingSizeLevel)

        let leftStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2

        let stack = UIStackView(arrangedSubviews: [leftStack, detailLabel])
        stack.distribution = .equalSpacing
        stack.alignment = .center

        bubbleView.addSubview(stack)
        stack.pinEdges([.left, .right], to: bubbleView.layoutMarginsGuide)
        stack.topAnchor.pin(greaterThan: bubbleView.layoutMarginsGuide.topAnchor)
        stack.bottomAnchor.pin(lessThan: bubbleView.layoutMarginsGuide.bottomAnchor)
        stack.centerYAnchor.pin(to: bubbleView.centerYAnchor)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let hideSubtitle = subtitleLabel.text == nil || subtitleLabel.text?.isEmpty == true
        if subtitleLabel.isHidden != hideSubtitle {
            subtitleLabel.isHidden = hideSubtitle
        }
    }

    func updateHighlight() {
        bubbleView.backgroundColor = (isSelected || isHighlighted) ? .bubbleBackgroundHighlight: .bubbleBackground
    }
}
