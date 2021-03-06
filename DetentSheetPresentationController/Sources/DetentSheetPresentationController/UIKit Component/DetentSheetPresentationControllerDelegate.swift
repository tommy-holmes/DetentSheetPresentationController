import UIKit

public protocol DetentSheetPresentationControllerDelegate: UIAdaptivePresentationControllerDelegate {
    func detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(_ detentSheetPresentationController: DetentSheetPresentationController) -> Void
}
