import UIKit

extension UIScrollView {
    var adjustedContentOffset: CGPoint {
        return CGPoint(x: contentOffset.x, y: contentOffset.y + safeAreaInsets.top + contentInset.top)
    }

//    func scrollToTop() {
//        if let selectorName = "X3Njcm9sbFRvVG9wSWZQb3NzaWJsZTo=".base64Decoded {
//            let selector = NSSelectorFromString(selectorName)
//            if responds(to: selector) {
//                perform(selector, with: false)
//            }
//        }
//    }
}
