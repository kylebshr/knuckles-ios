//
//  InformationalViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import UIKit

class InformationalViewController: UIViewController {

    private let balanceLabel = UILabel(font: .rubik(ofSize: 32, weight: .medium))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.layoutMargins = UIEdgeInsets(all: 36)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 35

        view.addSubview(stackView)
        stackView.pinEdges(to: view.layoutMarginsGuide)

        let topView = UIView()
        stackView.addArrangedSubview(topView)

        let helloLabel = UILabel(font: .rubik(ofSize: 18, weight: .regular))
        helloLabel.text = "Hello Jason 🎉"
        stackView.addArrangedSubview(helloLabel)

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .rubik(ofSize: 36, weight: .bold)

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

        let pageControl = PageControl()
        pageControl.numberOfPages = 4
        stackView.addArrangedSubview(pageControl)

        let middleView = UIView()
        stackView.addArrangedSubview(middleView)
        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.6)

        balanceLabel.text = NumberFormatter.currency.string(from: 1337.69)

        let availableLabel = UILabel(font: .rubik(ofSize: 14, weight: .regular), color: .secondaryLabel)
        availableLabel.text = "cash available"

        let labelStack = UIStackView(arrangedSubviews: [balanceLabel, availableLabel])
        labelStack.spacing = 4
        labelStack.axis = .vertical

        stackView.addArrangedSubview(labelStack)
    }
}
