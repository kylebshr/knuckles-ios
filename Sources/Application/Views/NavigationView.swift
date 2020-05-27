//
//  NavigationView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class NavigationView: ScrollViewShadowView {

    struct Action {
        var symbolName: String
        var onTap: () -> Void
    }

    var text: String = "" {
        didSet { label.text = text }
    }

    var action: Action? {
        didSet { updateAction() }
    }

    private let label = UILabel(font: .rubik(ofSize: 24, weight: .medium))
    private let actionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .customBackground
        layoutMargins = .init(top: 30, left: 30, bottom: 20, right: 30)

        addSubview(label)
        label.setHuggingAndCompression(to: .required)
        label.pinEdges([.left, .top, .bottom], to: layoutMarginsGuide)

        addSubview(actionButton)
        actionButton.tintColor = .customLabel
        actionButton.centerYAnchor.pin(to: label.centerYAnchor)
        actionButton.trailingAnchor.pin(to: layoutMarginsGuide.trailingAnchor)
        actionButton.addTarget(self, action: #selector(performAction), for: .primaryActionTriggered)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAction() {
        actionButton.isHidden = action == nil
        if let action = action {
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            actionButton.setImage(UIImage(systemName: action.symbolName, withConfiguration: config), for: .normal)
        }
    }

    @objc private func performAction() {
        action?.onTap()
    }
}
