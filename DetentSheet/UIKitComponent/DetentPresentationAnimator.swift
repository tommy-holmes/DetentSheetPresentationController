import UIKit

internal final class DetentPresentationAnimator: NSObject {
    let detents: [DetentPresentationController.Detent]
    let isPresentation: Bool
    
    init(detents: [DetentPresentationController.Detent], isPresentation: Bool) {
        self.detents = detents
        self.isPresentation = isPresentation
        super.init()
    }
}

extension DetentPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        controller.view.frame = initialFrame
        
        UIView.animate(withDuration: animationDuration) {
            controller.view.frame = finalFrame
        } completion: { finished in
            if !self.isPresentation {
                controller.view.removeFromSuperview()
            }
            transitionContext.completeTransition(finished)
        }
    }
}
