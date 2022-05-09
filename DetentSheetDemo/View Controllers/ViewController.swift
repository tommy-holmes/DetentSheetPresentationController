import UIKit
import DetentSheetPresentationController

class ViewController: UIViewController {
    
    lazy var transitionDelegate = DetentTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showSheet(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sheetVC = storyboard.instantiateViewController(identifier: "ShownVC")
        
        transitionDelegate.detents = [.small(), .medium()]
        
        sheetVC.transitioningDelegate = transitionDelegate
        sheetVC.modalPresentationStyle = .custom
        
        present(sheetVC, animated: true)
    }
    
}
