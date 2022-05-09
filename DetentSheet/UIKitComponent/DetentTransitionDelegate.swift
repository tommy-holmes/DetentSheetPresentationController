import UIKit

public final class DetentTransitionDelegate: NSObject {
    var detents: [DetentPresentationController.Detent] = []
    var preferredCornerRadius: CGFloat = 13
    var prefersSwipeToDismiss: Bool = false
}

extension DetentTransitionDelegate: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = DetentPresentationController(presentedVC: presented, presenting: presenting, detents: detents)
        presentationController.preferredCornerRadius = preferredCornerRadius
        presentationController.prefersSwipeToDismiss = prefersSwipeToDismiss
        
        return presentationController
    }
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        DetentPresentationAnimator(detents: detents, isPresentation: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DetentPresentationAnimator(detents: detents, isPresentation: false)
    }
}
