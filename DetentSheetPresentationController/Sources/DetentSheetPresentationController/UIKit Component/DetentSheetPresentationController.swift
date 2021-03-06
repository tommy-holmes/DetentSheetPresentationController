import UIKit

public final class DetentSheetPresentationController: UIPresentationController {
    public var detents: Set<Detent>
    public var preferredCornerRadius: CGFloat = 13
    public var prefersSwipeToDismiss: Bool = false
    public var largestUndimmedDetentIdentifier: Detent.Identifier = .medium
    public var selectedDetentIdentifier: Detent.Identifier? {
        didSet {
            moveTo(yPosition)
            detentDelegate?.detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(self)
            
            if selectedDetentIdentifier == .large {
                showDimmedView()
            } else {
                hideDimmedView()
            }
        }
    }
    
    public weak var detentDelegate: DetentSheetPresentationControllerDelegate?
    
    private var dimmedView: UIView!

    private var heightMultiplier: CGFloat {
        selectedDetentIdentifier == .small ? 1 / 4
        : selectedDetentIdentifier == .medium ? 1 / 2
        : 758 / 812
    }
    private var yPosition: CGFloat { UIScreen.main.bounds.height * (1 - heightMultiplier) }
    
    init(presentedVC: UIViewController, presenting: UIViewController?, detents: Set<Detent>) {
        self.detents = detents
        
        selectedDetentIdentifier = !detents.isEmpty ? detents.first?.id : .large
        
        super.init(presentedViewController: presentedVC, presenting: presenting)
        self.setupDimmedView()
    }
    
    public override func presentationTransitionWillBegin() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        containerView?.addGestureRecognizer(viewPan)
        
        if selectedDetentIdentifier == .large { showDimmedView() }
    }

    public override func dismissalTransitionWillBegin() {
        hideDimmedView()
    }
    
    public override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = preferredCornerRadius
        presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    public override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: parentSize.width, height: parentSize.height)
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
                
            } else if finalYPosition * 0.75 < mediumHeight && allowedDetentIds.contains(.medium) {
                selectedDetentIdentifier = .medium
                
            } else if finalYPosition * 0.85 < smallHeight && allowedDetentIds.contains(.small) {
                selectedDetentIdentifier = .small
                
            } else if prefersSwipeToDismiss {
                moveAndDismissPresentedView()
                
            } else {
                moveTo(yPosition)
            }
        default:
            break
        }
    }
}

private extension DetentSheetPresentationController {
    func moveTo(_ yPosition: CGFloat) {
        presentedViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn) {
            self.presentedViewController.view.frame.origin.y = yPosition
            self.presentedViewController.view.layoutIfNeeded()
        }
    }
    
    func moveAndDismissPresentedView() {
        presentedViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn) {
            self.presentedViewController.view.layoutIfNeeded()
        } completion: { _ in
            self.presentingViewController.dismiss(animated: true)
        }
    }
    
    func setPreferredContentSizeFromAutolayout() {
        let contentSize = self.containerView?.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        self.presentedViewController.preferredContentSize = contentSize!
    }
    
    func showDimmedView() {
        guard let dimmedView = dimmedView else { return }
        containerView?.insertSubview(dimmedView, at: 0)

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmedView]|", options: [], metrics: nil, views: ["dimmedView": dimmedView])
        )
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmedView]|", options: [], metrics: nil, views: ["dimmedView": dimmedView])
        )
        guard let coordinator = presentedViewController.transitionCoordinator else {
            UIView.animate(withDuration: 0.3) {
                dimmedView.alpha = 1
            }
            return
        }
        coordinator.animate { _ in self.dimmedView.alpha = 1 }
    }
    
    func hideDimmedView() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            UIView.animate(withDuration: 0.3) {
                self.dimmedView.alpha = 0
            } completion: { _ in
                self.dimmedView.removeFromSuperview()
            }
            return
        }

        coordinator.animate { _ in
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dimmedView.removeFromSuperview()
        }
    }
}

private extension DetentSheetPresentationController {
    func setupDimmedView() {
        dimmedView = UIView()
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimmedView.alpha = 0
    }
}

private final class PassthroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        false
    }
}
