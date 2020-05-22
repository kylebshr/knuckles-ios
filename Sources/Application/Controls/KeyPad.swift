//
//  KeyPad.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

protocol KeyPadDelegate: AnyObject {
    func keyPad(_ keyPad: KeyPad, didUpdateText text: String)
}

protocol KeyPadFormatter {
    var text: String { get }

    func appendCharacter(character: Character)
    func removeCharacter()
}

class KeyPad: UIView {

    weak var delegate: KeyPadDelegate?

    private let mainStackView = UIStackView()
    private let formatter: KeyPadFormatter

    init(formatter: KeyPadFormatter) {
        self.formatter = formatter

        super.init(frame: .zero)

        addSubview(mainStackView)
        mainStackView.pinEdges(to: self)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill

        let numberRows: [[Character]] =  [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
        ]

        for row in numberRows {
            let stackView = UIStackView(arrangedSubviews: row.map { number in
                let button = KeyPadButton(character: number)
                button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
                return button
            })

            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            mainStackView.addArrangedSubview(stackView)
        }

        let period = KeyPadButton(character: ".")
        period.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)

        let zero = KeyPadButton(character: "0")
        zero.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)

        let delete = DeleteButton()
        delete.addTarget(self, action: #selector(tappedDelete), for: .touchUpInside)

        let bottomStackView = UIStackView(arrangedSubviews: [period, zero, delete])
        bottomStackView.distribution = .fillEqually
        bottomStackView.alignment = .fill
        mainStackView.addArrangedSubview(bottomStackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tappedButton(sender: KeyPadButton) {
        formatter.appendCharacter(character: sender.character)
        delegate?.keyPad(self, didUpdateText: formatter.text)
    }

    @objc private func tappedDelete(sender: DeleteButton) {
        formatter.removeCharacter()
        delegate?.keyPad(self, didUpdateText: formatter.text)
    }
}

private class DeleteButton: Control {
    private let imageView = UIImageView()

    init() {
        super.init(frame: .zero)

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let image = UIImage(systemName: "delete.left", withConfiguration: config)!

        addSubview(imageView)
        imageView.pinEdges(to: self, insets: .init(vertical: 18, horizontal: 0))
        imageView.contentMode = .center
        imageView.tintColor = .label
        imageView.image = image
    }

    override func updateState() {
        imageView.alpha = isHighlighted ? 0.3 : 1
    }
}
