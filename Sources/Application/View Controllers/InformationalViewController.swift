//
//  InformationalViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import UIKit

class InformationalViewController: UIViewController {

    private let balanceLabel = UILabel(font: .boldSystemFont(ofSize: 32))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        view.addSubview(stackView)

        stackView.pinEdges(to: view.layoutMarginsGuide)
        stackView.distribution = .fill
        stackView.alignment = .fill

        let topView = UIView()
        stackView.addArrangedSubview(topView)

        let helloLabel = UILabel(font: .systemFont(ofSize: 18))
        helloLabel.text = "Hello Jason 🌙"
        stackView.addArrangedSubview(helloLabel)
        stackView.setCustomSpacing(40, after: helloLabel)

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 36, weight: .heavy)

        let string = "What if you could change the world with just your mind?"
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 36 * 1.3
        paragraphStyle.maximumLineHeight = 36 * 1.3

        attributedString.addAttribute(.foregroundColor, value: UIColor(displayP3Red: 0.325, green: 0.596, blue: 1, alpha: 1),
                                      range: (string as NSString).range(of: "change the world"))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))

        label.attributedText = attributedString
        stackView.addArrangedSubview(label)

        let middleView = UIView()
        stackView.addArrangedSubview(middleView)
        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.6)

        stackView.addArrangedSubview(balanceLabel)
        balanceLabel.text = NumberFormatter.currency.string(from: 1337.69)

        let availableLabel = UILabel(font: .systemFont(ofSize: 14), color: .secondaryLabel)
        availableLabel.text = "cash available"
        stackView.addArrangedSubview(availableLabel)
    }
}
