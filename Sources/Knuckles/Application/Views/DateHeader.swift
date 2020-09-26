//
//  DateHeader.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/24/20.
//

import UIKit

class DateHeader: UICollectionReusableView {

    private let titleLabel = UILabel(font: .systemFont(ofSize: 15, weight: .semibold), color: .customSecondaryLabel)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .customBackground

        addSubview(titleLabel)
        titleLabel.pinEdges(to: self, insets: .init(top: 15, left: 0, bottom: 15, right: 0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(date: Date) {
        display(text: DateFormatter.readyByFormatter.string(from: date))
    }

    func display(text: String) {
        titleLabel.text = text
    }
}
