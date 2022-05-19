import UIKit
import DetentSheetPresentationController

final class ShownViewController: UIViewController {
    
    @IBOutlet private weak var dismissButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        let presentationController = presentationController as? DetentSheetPresentationController
        presentationController?.detentDelegate = self
    }
    
    @IBAction private func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ShownViewController: DetentSheetPresentationControllerDelegate {
    func detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(_ detentSheetPresentationController: DetentSheetPresentationController) {
        guard let currentDetent = detentSheetPresentationController.selectedDetentIdentifier else { return }
        
        dismissButton.titleLabel?.text = currentDetent.rawValue.capitalized
//        self.view.bounds = CGRect(
//            origin: CGPoint(x: 0, y: 0),
//            size: CGSize(
//                width: UIScreen.main.bounds.width,
//                height: UIScreen.main.bounds.height - detentSheetPresentationController.frameOfPresentedViewInContainerView.origin.y
//            )
//        )
//        self.view.topAnchor.constraint(equalTo: detentSheetPresentationController.presentedViewController.view.topAnchor, constant: 0).isActive = true
//        self.view.bounds.origin.y = detentSheetPresentationController.frameOfPresentedViewInContainerView.origin.y
//        self.view.backgroundColor = .red
//        print("Bounds:", self.view.layer.bounds, "Sheet:", detentSheetPresentationController.frameOfPresentedViewInContainerView)
    }
}
