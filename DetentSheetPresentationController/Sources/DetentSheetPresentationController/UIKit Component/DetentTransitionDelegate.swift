import UIKit

public final class DetentTransitionDelegate: NSObject {
    public var detents: [DetentSheetPresentationController.Detent] = []
    public var preferredCornerRadius: CGFloat = 13
    public var prefersSwipeToDismiss: Bool = false
}

extension DetentTransitionDelegate: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = DetentSheetPresentationController(presentedVC: presented, presenting: presenting, detents: detents)
        presentationController.preferredCornerRadius = preferredCornerRadius
        presentationController.prefersSwipeToDismiss = prefersSwipeToDismiss
        
        return presentationController
    }
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        DetentPresentationAnimator(isPresenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DetentPresentationAnimator(isPresenting: false)
    }
}
