//
//  SlideNavigationTransition.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class SlideNavigationController: UINavigationController, UINavigationControllerDelegate {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setNavigationBarHidden(true, animated: false)
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        SlideAnimationTransition(operation: operation)
    }

}

class SlideAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let operation: UINavigationController.Operation

    init(operation: UINavigationController.Operation) {
        self.operation = operation
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView

        containerView.addSubview(toView)
        toView.frame = containerView.bounds
        toView.layoutIfNeeded()

        switch operation {
        case .push: toView.frame.origin.x += toView.frame.width
        default: toView.frame.origin.x -= toView.frame.width
        }

        let animator = UIViewPropertyAnimator {
            toView.frame = containerView.bounds

            switch self.operation {
            case .push: fromView.frame.origin.x -= fromView.frame.width
            default: fromView.frame.origin.x += fromView.frame.width
            }
        }

        animator.addCompletion { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

        animator.startAnimation()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
}
