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
    private let nextButton = Button(title: "Next")
    private let dayLabel = UILabel(font: .systemFont(ofSize: 64, weight: .bold), alignment: .center)
    private let perMonthLabel = UILabel(font: .systemFont(ofSize: 18, weight: .medium), color: .customSecondaryLabel, alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "What day is it due?"

        view.addSubview(nextButton)
        nextButton.pinEdges([.left, .right, .bottom], to: view.safeAreaLayoutGuide, insets: .init(all: 20))
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

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
        stackView.topAnchor.pin(to: view.layoutMarginsGuide.topAnchor)
        stackView.bottomAnchor.pin(to: nextButton.topAnchor)
    }

    @objc private func didTapNext() {
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
