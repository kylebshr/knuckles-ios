//
//  NSCollectionLayoutSection+Layouts.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/24/20.
//

import UIKit

extension NSCollectionLayoutSection {
    static func bubbleCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 15, bottom: 15, trailing: 15)
        section.interGroupSpacing = 10

        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(80))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]

        return section
    }
}

extension UICollectionViewLayout {
    static func bubble() -> UICollectionViewCompositionalLayout {
        .init(section: .bubbleCellLayout())
    }

    @available(iOS 14, *)
    static func grouped(trailingSwipeActionsProvider: UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider? = nil)
    -> UICollectionViewCompositionalLayout {
        var layout = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layout.backgroundColor = .customBackground
        layout.headerMode = .supplementary
        layout.trailingSwipeActionsConfigurationProvider = trailingSwipeActionsProvider
        return UICollectionViewCompositionalLayout.list(using: layout)
    }
}
