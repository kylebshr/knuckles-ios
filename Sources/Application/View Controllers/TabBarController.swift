//
//  TabBarController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/27/20.
//

import UIKit

enum TabBarItem {
    case symbol(String)
    case text(String)
}

protocol TabbedViewController {
    var scrollView: UIScrollView? { get }
    var tabItem: TabBarItem { get }
}

class TabBarController: ViewController {
    private let stackView = UIStackView()
    private let tabBarContainerView = ScrollViewShadowView()

    private var buttons: [TabBarControl] {
        guard let buttons = stackView.arrangedSubviews as? [TabBarControl] else {
            fatalError()
        }

        return buttons
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarContainerView.addSubview(stackView)
        stackView.pinEdges(to: tabBarContainerView.safeAreaLayoutGuide)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        view.addSubview(tabBarContainerView)
        tabBarContainerView.pinEdges([.left, .right, .bottom], to: view)
        tabBarContainerView.topAnchor.pin(to: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
    }

    var viewControllers: [UIViewController & TabbedViewController] = [] {
        didSet { updateViewControllers() }
    }

    private func updateViewControllers() {
        updateTabs()

        if viewControllers.isEmpty {
            children.first?.remove()
        } else {
            select(index: 0)
        }
    }

    private func select(index: Int) {
        children.first?.remove()

        add(viewControllers[index]) { view in
            self.view.insertSubview(view, at: 0)
            view.pinEdges([.left, .right, .top], to: self.view)
            view.bottomAnchor.pin(to: self.tabBarContainerView.topAnchor)
        }

        for (i, view) in buttons.enumerated() {
            view.isSelected = i == index
        }

        tabBarContainerView.observe(scrollView: viewControllers[index].scrollView)
    }

    private func updateTabs() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for vc in viewControllers {
            let button = TabBarControl(item: vc.tabItem)
            button.addTarget(self, action: #selector(selectTab), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    @objc private func selectTab(sender: TabBarControl) {
        let index = buttons.firstIndex(of: sender)!
        select(index: index)
    }
}

private class TabBarControl: Control {

    private let content: UIView

    init(item: TabBarItem) {
        switch item {
        case .symbol(let name):
            let imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
            imageView.contentMode = .center
            imageView.tintColor = .customLabel
            imageView.image = UIImage(systemName: name, withConfiguration: config)!
            content = imageView
        case .text(let text):
            let label = UILabel(font: .rubik(ofSize: 18, weight: .bold), alignment: .center)
            label.text = text
            content = label
        }

        super.init(frame: .zero)
        addSubview(content)
        content.pinEdges(to: self)
    }

    override func updateState() {
        UIView.performWithoutAnimation {
            alpha = isSelected ? 1 : 0.5
        }
    }
}
