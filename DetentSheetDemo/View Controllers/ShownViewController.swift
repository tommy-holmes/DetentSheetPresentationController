import UIKit
import DetentSheetPresentationController

final class ShownViewController: UIViewController {
    
    @IBOutlet private weak var dismissButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let presentationController = presentationController as? DetentSheetPresentationController
        presentationController?.detentDelegate = self
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ShownViewController: DetentSheetPresentationControllerDelegate {
    func detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(_ detentSheetPresentationController: DetentSheetPresentationController) {
        guard let currentDetent = detentSheetPresentationController.selectedDetentIdentifier else { return }
        
        dismissButton.titleLabel?.text = currentDetent.rawValue
    }
}
