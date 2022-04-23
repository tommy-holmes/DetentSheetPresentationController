import UIKit

public final class DetentPresentationController: UIPresentationController {
    var detents: [Detent]
    var preferredCornerRadius: CGFloat = 16
    var largestUndimmedDetentIdentifier: Detent.Identifier = .medium
    
    private(set) var selectedDetentIdentifier: Detent.Identifier?
    
    private var dimmedView: UIView!

    private var heightMultiplier: CGFloat {
        selectedDetentIdentifier == .small ? 1 / 4
        : selectedDetentIdentifier == .medium ? 1 / 2
        : 758 / 812
    }
    private var yPosition: CGFloat { UIScreen.main.bounds.height * (1 - heightMultiplier) }
    
    init(presentedVC: UIViewController, presenting: UIViewController?, detents: [Detent]) {
        self.detents = detents
        
        selectedDetentIdentifier = !detents.isEmpty ? detents[0].id : .large // TODO: If the default value is nil, that means the sheet displays at the smallest detent you specify in detents.
        
        super.init(presentedViewController: presentedVC, presenting: presenting)
        self.setupDimmedView()
    }
    
    public override func presentationTransitionWillBegin() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        containerView?.addGestureRecognizer(viewPan)
        
        guard let dimmedView = dimmedView else { return }
        containerView?.insertSubview(dimmedView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmedView]|", options: [], metrics: nil, views: ["dimmedView": dimmedView])
        )
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmedView]|", options: [], metrics: nil, views: ["dimmedView": dimmedView])
        )
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmedView.alpha = 1.0
            return
        }
        coordinator.animate { _ in self.dimmedView.alpha = 1.0 }
    }
    
    public override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmedView.alpha = 0.0
            return
        }
        
        coordinator.animate { _ in self.dimmedView.alpha = 0.0 }
    }
    
    public override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = preferredCornerRadius
        presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    public override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: parentSize.width, height: parentSize.height * heightMultiplier)
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        frame.origin = .init(x: 0, y: yPosition)
        
        return frame
    }
    
    @objc private func viewPanned(_ sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: self.presentedView)
        
        switch sender.state {
        case .changed:
            if yPosition + translate.y > 0 {
                presentedViewController.view.frame.origin.y = yPosition + translate.y
            }
        case .ended:
            let finalYPosition = presentedViewController.view.frame.origin.y
            let allowedDetentIds = detents.map { $0.id }
            
            let screenHeight = UIScreen.main.bounds.height
            let largeHeight = screenHeight - screenHeight * 758 / 812
            let mediumHeight = screenHeight - screenHeight * 1 / 2
            let smallHeight = screenHeight - screenHeight * 1 / 4
            
            if finalYPosition * 0.25 < largeHeight && allowedDetentIds.contains(.large) {
                selectedDetentIdentifier = .large
                moveToPosition(yPosition)
                
            } else if finalYPosition * 0.75 < mediumHeight && allowedDetentIds.contains(.medium) {
                selectedDetentIdentifier = .medium
                moveToPosition(yPosition)
                
            } else if finalYPosition * 0.85 < smallHeight && allowedDetentIds.contains(.small) {
                selectedDetentIdentifier = .small
                moveToPosition(yPosition)
                
            } else {
                moveAndDismissPresentedView()
            }
        default:
            break
        }
    }
}

extension DetentPresentationController {
    private func moveToPosition(_ yPosition: CGFloat) {
        presentedViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn) {
            self.presentedViewController.view.frame.origin.y = yPosition
            self.presentedViewController.view.layoutIfNeeded()
            self.containerView?.setNeedsLayout()
        }
    }
    
    private func moveAndDismissPresentedView() {
        presentedViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn) {
            self.presentedViewController.view.layoutIfNeeded()
        } completion: { _ in
            self.presentingViewController.dismiss(animated: true)
        }
    }
}

extension DetentPresentationController {
    private func setupDimmedView() {
        dimmedView = UIView()
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmedView.alpha = 0.0
    }
}

extension DetentPresentationController {
    public final class Detent: NSObject {
        var id: Identifier

        required init(_ id: Identifier) {
            self.id = id
        }

        public class func small() -> Self {
            return Self(.small)
        }
        public class func medium() -> Self {
            return Self(.medium)
        }
        public class func large() -> Self {
            return Self(.large)
        }
    }
}

extension DetentPresentationController.Detent {
    struct Identifier: @unchecked Sendable, Equatable, Hashable, RawRepresentable {
        let rawValue: String
    }
}

extension DetentPresentationController.Detent.Identifier {
    static let small: Self = .init(rawValue: "small")
    static let medium: Self = .init(rawValue: "medium")
    static let large: Self = .init(rawValue: "large")
}
