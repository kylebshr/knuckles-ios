import UIKit

private let minimumDimension: CGFloat = 44

extension UIView {
    var safeIsHidden: Bool {
        get { isHidden }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }

    func setHuggingAndCompression(to priority: UILayoutPriority) {
        set(contentHugging: priority, for: .horizontal)
        set(contentHugging: priority, for: .vertical)
        set(compressionResistance: priority, for: .horizontal)
        set(compressionResistance: priority, for: .vertical)
    }

    func setHuggingAndCompression(to priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        set(contentHugging: priority, for: axis)
        set(compressionResistance: priority, for: axis)
    }

    func set(contentHugging: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(contentHugging, for: axis)
    }

    func set(compressionResistance: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(compressionResistance, for: axis)
    }

    func isPointInsideMinimum(_ point: CGPoint) -> Bool {
        let outsetX = max(0, (minimumDimension - bounds.width) / 2)
        let outsetY = max(0, (minimumDimension - bounds.height) / 2)
        return bounds.insetBy(dx: -outsetX, dy: -outsetY).contains(point)
    }

    func setFlashing(_ isFlashing: Bool) {
        if isFlashing {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = 0.6
            animation.fromValue = 1
            animation.toValue = 0.3
            animation.autoreverses = true
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.repeatCount = .infinity
            layer.add(animation, forKey: #function)
        } else {
            layer.removeAnimation(forKey: #function)
        }
    }
}
