//
//  NavigationView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

private let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)

class NavigationView: UIView {

    struct Action {
        var symbolName: String
        var onTap: () -> Void
    }

    var text: String = "" {
        didSet { label.text = text }
    }

    var leftAction: Action? {
        didSet { updateActions() }
    }

    var rightAction: Action? {
        didSet { updateActions() }
    }

    private let label = UILabel(font: .systemFont(ofSize: 24, weight: .medium))
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .customBackground
        layoutMargins = .init(top: 20, left: 30, bottom: 20, right: 30)

        let stackView = UIStackView(arrangedSubviews: [leftButton, label, rightButton])
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10

        label.setHuggingAndCompression(to: .required, for: .vertical)
        leftButton.addTarget(self, action: #selector(performLeftAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(performRightAction), for: .touchUpInside)

        for button in [leftButton, rightButton] {
            button.tintColor = .customLabel
            button.setHuggingAndCompression(to: .required)
        }

        addSubview(stackView)
        stackView.pinEdges(to: layoutMarginsGuide)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateActions() {
        leftButton.isHidden = leftAction == nil
        rightButton.alpha = rightAction == nil ? 0 : 1

        label.textAlignment = leftAction == nil ? .left : .center

        if let leftAction = leftAction {
            let image = UIImage(systemName: leftAction.symbolName, withConfiguration: symbolConfig)!
            leftButton.setImage(image, for: .normal)
        }

        if let rightAction = rightAction {
            let image = UIImage(systemName: rightAction.symbolName, withConfiguration: symbolConfig)!
            rightButton.setImage(image, for: .normal)
        }
    }

    @objc private func performLeftAction() {
        leftAction?.onTap()
    }

    @objc private func performRightAction() {
        rightAction?.onTap()
    }
}
