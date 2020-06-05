import UIKit

extension UIViewPropertyAnimator {
    convenience init(system animations: @escaping () -> Void) {
        let params = UISpringTimingParameters()
        self.init(duration: 1, timingParameters: params)
        addAnimations(animations)
    }
}
