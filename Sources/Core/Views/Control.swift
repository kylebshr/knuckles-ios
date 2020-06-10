import UIKit

class Control: UIControl {

    override var isHighlighted: Bool {
        didSet { if isHighlighted != oldValue { setNeedsStateUpdate() } }
    }

    override var isEnabled: Bool {
        didSet { if isEnabled != oldValue { setNeedsStateUpdate() } }
    }

    override var isSelected: Bool {
        didSet { if isSelected != oldValue { setNeedsStateUpdate() } }
    }

    /// A Boolean value indicating whether the control is in the loading state.
    var isLoading: Bool = false {
        didSet { if isLoading != oldValue { setNeedsStateUpdate() } }
    }

    private var scheduledStateUpdate: DispatchWorkItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        isAccessibilityElement = true
        accessibilityTraits = .button
        updateState()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Overriding this method allows us to expand our bounds for the hit test of this control.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }

    /// In almost every case, a view added as a subview to a control shouldn't have user interaction.
    override func addSubview(_ view: UIView) {
        view.isUserInteractionEnabled = false
        super.addSubview(view)
    }

    /// Call this function to schedule an update to the controls state.
    /// This debounces state changes that happen in the same runloop.
    func setNeedsStateUpdate(animated: Bool = true) {
        scheduledStateUpdate?.cancel()

        scheduledStateUpdate = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if animated {
                UIViewPropertyAnimator(system: self.updateState).startAnimation()
            } else {
                self.updateState()
            }
        }

        DispatchQueue.main.async(execute: scheduledStateUpdate!)
    }

    /// Subclasses should override this method to update their appearance based on the state property.
    /// Generally you should call `setNeedsStateUpdate` instead of calling this directly.
    func updateState() {}

    /// This method is called whenever the control receives a touchUpInside event.
    @objc func touchUpInside() {}
}
