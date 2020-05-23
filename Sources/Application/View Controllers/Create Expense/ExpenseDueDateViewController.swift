//
//  DueDateViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseDueDateViewController: FlowViewController {

    var didEnterDay: ((Int) -> Void)?

    private var day: Int? {
        didSet { updateDay() }
    }

    private let dayPickerView = DayPickerView()
    private let nextButton = FullWidthButton()
    private let dayLabel = UILabel(font: .rubik(ofSize: 72, weight: .bold), alignment: .center)
    private let perMonthLabel = UILabel(font: .rubik(ofSize: 18, weight: .regular), color: .secondaryLabel, alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.text = "What day is it due?"

        view.addSubview(nextButton)
        nextButton.text = "Add to expenses"
        nextButton.pinEdges([.left, .right, .bottom], to: view)
        nextButton.onTap = { [weak self] in self?.didTapNext() }

        dayPickerView.didTapDay = { [weak self] in self?.day = $0 }
        dayLabel.text = "1st"
        dayLabel.alpha = 0
        perMonthLabel.text = "of every month"
        perMonthLabel.alpha = 0

        let labelStack = UIStackView(arrangedSubviews: [dayLabel, perMonthLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .center

        let topView = UIView()
        let middleView = UIView()
        let bottomView = UIView()

        let stackView = UIStackView(arrangedSubviews: [topView, dayPickerView, middleView, labelStack, bottomView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill

        view.addSubview(stackView)

        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.5)
        bottomView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.7)

        stackView.pinEdges([.left, .right], to: view.layoutMarginsGuide)
        stackView.topAnchor.pin(to: navigationView.bottomAnchor)
        stackView.bottomAnchor.pin(to: nextButton.topAnchor)
    }

    private func didTapNext() {
        guard let day = day else {
            return
        }

        didEnterDay?(day)
    }

    private func updateDay() {
        guard let day = day else { return }
        dayLabel.text = NumberFormatter.ordinal.string(from: day as NSNumber)
        dayLabel.alpha = 1
        perMonthLabel.alpha = 1
    }
}
