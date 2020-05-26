import UIKit

class Button: Control {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let dimmingView = UIView()
    private let content: UIView

    convenience init(title: String) {
        let label = UILabel(font: .systemFont(ofSize: 21, weight: .semibold), color: .label)
        label.textAlignment = .center
        label.text = title
        self.init(content: label)
    }

    private init(content: UIView) {
        self.content = content

        super.init(frame: .zero)

        clipsToBounds = true
        backgroundColor = .customBlue

        addSubview(dimmingView)
        dimmingView.alpha = 0
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.pinEdges(to: self)

        addSubview(content)
        content.pinEdges(to: self)

        widthAnchor.pin(greaterThan: heightAnchor)
        widthAnchor.pin(to: 0, priority: .fittingSizeLevel)
        heightAnchor.pin(to: 55)

        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.pinCenter(to: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.midY
    }

    override func updateState() {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        dimmingView.alpha = self.isHighlighted ? 1 : 0
        activityIndicator.alpha = self.isLoading ? 1 : 0
        content.alpha = self.isLoading ? 0 : 1
        alpha = self.isEnabled ? 1 : 0.5
    }
}
