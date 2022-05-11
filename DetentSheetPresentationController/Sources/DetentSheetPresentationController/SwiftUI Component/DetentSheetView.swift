import SwiftUI

fileprivate struct DetentSheetViewWrapper<Content: View>: UIViewRepresentable {
    @Binding var isPresented: Bool
    let detents: [DetentSheetPresentationController.Detent]
    let preferredCornerRadius: CGFloat
    let content: Content
    
    private(set) var currentDetentID: DetentSheetPresentationController.Detent.Identifier?
    private let transitionDelegate = DetentTransitionDelegate()
    
    func makeUIView(context: Context) -> UIView { .init() }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            isPresented: $isPresented,
            selectedDetentID: currentDetentID
        )
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let presentedVC = UIViewController()
        let hostingController = UIHostingController(rootView: content)
        
        presentedVC.addChild(hostingController)
        presentedVC.view.addSubview(hostingController.view)
        
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
        
        if isPresented {
            uiView.window?.rootViewController?.present(presentedVC, animated: true)
        } else {
            uiView.window?.rootViewController?.dismiss(animated: true)
        }
    }
}

private extension DetentSheetViewWrapper {
    final class Coordinator: NSObject, DetentSheetPresentationControllerDelegate {
        @Binding var isPresented: Bool
        var selectedDetentID: DetentSheetPresentationController.Detent.Identifier?
        
        init(
            isPresented: Binding<Bool>,
            selectedDetentID: DetentSheetPresentationController.Detent.Identifier?
        ) {
            _isPresented = isPresented
            self.selectedDetentID = selectedDetentID
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented = false
        }
        
        func detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(_ detentSheetPresentationController: DetentSheetPresentationController) {
            selectedDetentID = detentSheetPresentationController.selectedDetentIdentifier
        }
    }
}

struct DetentSheetView<Content: View>: View {
    @Binding var isPresented: Bool

    @State private var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?

    let detents: [DetentSheetPresentationController.Detent]
    let preferredCornerRadius: CGFloat
    var content: Content

    init(
        isPresented: Binding<Bool>,
        detents: [DetentSheetPresentationController.Detent] = [.large()],
        preferredCornerRadius: CGFloat = 13,
        @ViewBuilder content: () -> Content
    ) {
        _isPresented = isPresented
        self.detents = detents
        self.preferredCornerRadius = preferredCornerRadius
        self.content = content()
    }

    var body: some View {
        DetentSheetViewWrapper(
            isPresented: $isPresented,
            detents: detents,
            preferredCornerRadius: preferredCornerRadius,
            content: content
        )
    }
}
