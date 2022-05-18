import UIKit
import SwiftUI

final class DetentSheetViewController<Content: View>: UIViewController, DetentSheetPresentationControllerDelegate {
    @Binding var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?
    
    private let contentView: UIHostingController<Content>
    
    init(
        selectedDetentIdentifier: Binding<DetentSheetPresentationController.Detent.Identifier?>,
        content: Content
    ) {
        _selectedDetentIdentifier = selectedDetentIdentifier
        self.contentView = UIHostingController(rootView: content)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(contentView)
        view.addSubview(contentView.view)
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if let presentationController = presentationController as? DetentSheetPresentationController {
            presentationController.detentDelegate = self
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        selectedDetentIdentifier = nil
    }

    func detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(_ detentSheetPresentationController: DetentSheetPresentationController) {
        selectedDetentIdentifier = detentSheetPresentationController.selectedDetentIdentifier
    }
}
