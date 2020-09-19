//
//  KeyPad.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

protocol KeyPadViewDelegate: AnyObject {
    func keyPadView(_ keyPadView: KeyPadView, didUpdateText text: String)
}

protocol KeyPadViewFormatter {
    var text: String { get }

    func appendCharacter(character: Character)
    func removeCharacter()
}

class KeyPadView: UIView {

    weak var delegate: KeyPadViewDelegate?

    private let mainStackView = UIStackView()
    private let formatter: KeyPadViewFormatter

    init(formatter: KeyPadViewFormatter) {
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

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 280)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tappedButton(sender: KeyPadButton) {
        formatter.appendCharacter(character: sender.character)
        delegate?.keyPadView(self, didUpdateText: formatter.text)
    }

    @objc private func tappedDelete(sender: DeleteButton) {
        formatter.removeCharacter()
        delegate?.keyPadView(self, didUpdateText: formatter.text)
    }
}

private class DeleteButton: Control {
    private let imageView = UIImageView()

    init() {
        super.init(frame: .zero)

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let image = UIImage(systemName: "delete.left", withConfiguration: config)!

        addSubview(imageView)
        imageView.pinEdges(to: self, insets: .init(vertical: 4, horizontal: 0))
        imageView.contentMode = .center
        imageView.tintColor = .customLabel
        imageView.image = image
    }

    override func updateState() {
        imageView.alpha = isHighlighted ? 0.3 : 1
    }
}

private class KeyPadButton: Control {

    let character: Character

    private let label = UILabel(font: .systemFont(ofSize: 24, weight: .semibold))

    init(character: Character) {
        self.character = character

        super.init(frame: .zero)

        addSubview(label)
        label.text = "\(character)"
        label.pinEdges(to: self, insets: .init(vertical: 4, horizontal: 0))
        label.textAlignment = .center
    }

    override func updateState() {
        label.alpha = isHighlighted ? 0.3 : 1
    }
}
