import UIKit

final class DetentTransitionDelegate: NSObject {
    var detents: [DetentPresentationController.Detent] = []
    var preferredCornerRadius: CGFloat = 16
}

extension DetentTransitionDelegate: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = DetentPresentationController(presentedVC: presented, presenting: presenting, detents: detents)
        presentationController.preferredCornerRadius = preferredCornerRadius
        
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DetentPresentationAnimator(detents: detents, isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DetentPresentationAnimator(detents: detents, isPresentation: false)
    }
}
