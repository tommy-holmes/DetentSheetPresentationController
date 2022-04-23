import UIKit

class ViewController: UIViewController {
    
    lazy var transitionDelegate = DetentTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showSheet(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "ShownVC")
        
        transitionDelegate.detents = [.small(), .medium(), .large()]
        
        secondVC.transitioningDelegate = transitionDelegate
        secondVC.modalPresentationStyle = .custom
        
        present(secondVC, animated: true)
    }
    
}
