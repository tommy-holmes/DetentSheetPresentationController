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

//extension DetentTransitionDelegate: UIAdaptivePresentationControllerDelegate {
//    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
//        print("willPresent")
//    }
//
//    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//        nil
//    }
//}
