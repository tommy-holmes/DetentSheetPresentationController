import UIKit
import SwiftUI

final class DetentSheetSwiftUIViewController<Content: View>: UIViewController, DetentSheetPresentationControllerDelegate {
    private var detents: [DetentSheetPresentationController.Detent]
    private var preferredCornerRadius: CGFloat
    private var prefersSwipeToDismiss: Bool
    private var largestUndimmedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier
    @Binding private var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?
    
    private let contentView: UIHostingController<Content>
    
    init(
        detents: [DetentSheetPresentationController.Detent],
        preferredCornerRadius: CGFloat = 13,
        prefersSwipeToDismiss: Bool = false,
        largestUndimmedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier = .medium,
        selectedDetentIdentifier: Binding<DetentSheetPresentationController.Detent.Identifier?>,
        content: Content
    ) {
        self.detents = detents
        self.preferredCornerRadius = preferredCornerRadius
        self.prefersSwipeToDismiss = prefersSwipeToDismiss
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
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
            presentationController.detents = detents
            presentationController.selectedDetentIdentifier = selectedDetentIdentifier
            presentationController.preferredCornerRadius = preferredCornerRadius
            presentationController.prefersSwipeToDismiss = prefersSwipeToDismiss
            presentationController.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
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
