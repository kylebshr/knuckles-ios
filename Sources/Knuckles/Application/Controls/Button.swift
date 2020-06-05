import UIKit

class Button: Control {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let content: UIView

    convenience init(title: String) {
        let label = UILabel(font: .rubik(ofSize: 18, weight: .medium),
                            color: .systemBackground,
                            alignment: .center)
        label.text = title
        self.init(content: label)
    }

    private init(content: UIView) {
        self.content = content

        super.init(frame: .zero)

        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .label

        addSubview(content)
        content.pinEdges(to: self)

        widthAnchor.pin(greaterThan: heightAnchor)
        widthAnchor.pin(to: 0, priority: .fittingSizeLevel)
        heightAnchor.pin(to: 55)

        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemBackground
        activityIndicator.pinCenter(to: self)
    }

    override func updateState() {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        activityIndicator.alpha = isLoading ? 1 : 0

        if isLoading {
            content.alpha = 0
        } else {
            content.alpha = (isHighlighted || !isEnabled) ? 0.3 : 1
        }
    }
}
