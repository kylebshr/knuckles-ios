//
//  SlideNavigationTransition.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class SlideNavigationController: UINavigationController, UINavigationControllerDelegate {

    private let gesture = UIScreenEdgePanGestureRecognizer()

    private var interaction: UIPercentDrivenInteractiveTransition?

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        setNavigationBarHidden(true, animated: false)
        delegate = self

        gesture.edges = .left
        gesture.addTarget(self, action: #selector(pan))
        view.addGestureRecognizer(gesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func pan(sender: UIPanGestureRecognizer) {
        let percent = sender.translation(in: view).x / view.frame.width

        switch sender.state {
        case .began:

            interaction = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)

        case .changed:

            interaction?.update(percent)

        case .ended:

            let velocity = sender.velocity(in: view).x

            if velocity > 0 || velocity == 0 && percent > 0.5 {
                interaction?.finish()
            } else {
                interaction?.cancel()
            }

            interaction = nil

        default:

            interaction?.cancel()
            interaction = nil

        }
    }

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        interaction
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
    private var animator: UIViewPropertyAnimator?

    init(operation: UINavigationController.Operation) {
        self.operation = operation
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animator = animator {
            return animator
        }

        guard let fromView = transitionContext.view(forKey: .from) else { fatalError() }
        guard let toView = transitionContext.view(forKey: .to) else { fatalError() }

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
            if transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(false)
                toView.removeFromSuperview()
            } else {
                transitionContext.completeTransition(true)
                fromView.removeFromSuperview()
            }

            self.animator = nil
        }

        self.animator = animator
        return animator
    }
}
