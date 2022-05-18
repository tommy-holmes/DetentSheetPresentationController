import SwiftUI

fileprivate struct DetentSheetViewWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?
    let detents: [DetentSheetPresentationController.Detent]
    let preferredCornerRadius: CGFloat
    let content: Content
    
    private let transitionDelegate = DetentTransitionDelegate()
    
    func makeUIViewController(context: Context) -> UIViewController { .init() }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            selectedDetentID: $selectedDetentIdentifier
        )
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let presentedVC = UIViewController()
        let hostingController = UIHostingController(rootView: content)
        
        presentedVC.addChild(hostingController)
        presentedVC.view.addSubview(hostingController.view)
        
        transitionDelegate.detents = detents
        
        presentedVC.transitioningDelegate = transitionDelegate
        presentedVC.modalPresentationStyle = .custom
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.leftAnchor.constraint(equalTo: presentedVC.view.leftAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: presentedVC.view.topAnchor).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: presentedVC.view.rightAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: presentedVC.view.bottomAnchor).isActive = true
        hostingController.didMove(toParent: presentedVC)
        
        if let sheetController = presentedVC.presentationController as? DetentSheetPresentationController {
            sheetController.detents = detents
            sheetController.preferredCornerRadius = preferredCornerRadius
        }
        
        presentedVC.presentationController?.delegate = context.coordinator
        
//        if selectedDetentIdentifier != nil {
//            uiViewController.window?.rootViewController?.present(presentedVC, animated: true)
//        } else {
//            uiViewController.window?.rootViewController?.dismiss(animated: true)
//        }
    }
}

private extension DetentSheetViewWrapper {
    final class Coordinator: NSObject, DetentSheetPresentationControllerDelegate {
        @Binding var selectedDetentID: DetentSheetPresentationController.Detent.Identifier?
        
        init(
            selectedDetentID: Binding<DetentSheetPresentationController.Detent.Identifier?>
        ) {
            _selectedDetentID = selectedDetentID
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            selectedDetentID = nil
        }
        
        func detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(_ detentSheetPresentationController: DetentSheetPresentationController) {
            selectedDetentID = detentSheetPresentationController.selectedDetentIdentifier
        }
    }
}

struct DetentSheetView<Content: View>: View {
    @Binding var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?

    let detents: [DetentSheetPresentationController.Detent]
    let preferredCornerRadius: CGFloat
    var content: Content

    init(
        selectedDetentIdentifier: Binding<DetentSheetPresentationController.Detent.Identifier?>,
        detents: [DetentSheetPresentationController.Detent] = [.large()],
        preferredCornerRadius: CGFloat = 13,
        @ViewBuilder content: () -> Content
    ) {
        _selectedDetentIdentifier = selectedDetentIdentifier
        self.detents = detents
        self.preferredCornerRadius = preferredCornerRadius
        self.content = content()
    }

    var body: some View {
        DetentSheetViewWrapper(
            selectedDetentIdentifier: $selectedDetentIdentifier,
            detents: detents,
            preferredCornerRadius: preferredCornerRadius,
            content: content
        )
    }
}
