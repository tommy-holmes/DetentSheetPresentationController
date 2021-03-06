import SwiftUI

public extension View {
    func detentSheet<Content: View>(
        selectedDetentIdentifier: Binding<DetentSheetPresentationController.Detent.Identifier?>,
        allowedDetents: Set<DetentSheetPresentationController.Detent>,
        preferedCornerRadius: CGFloat = 13,
        prefersSwipeToDismiss: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            DetentSheetModifier(
                selectedDetentIdentifier: selectedDetentIdentifier,
                detents: allowedDetents,
                preferredCornerRadius: preferedCornerRadius,
                prefersSwipeToDismiss: prefersSwipeToDismiss,
                sheetContent: content
            )
        )
    }
}

private struct DetentSheetModifier<C: View>: ViewModifier {
    @Binding var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?
    var detents: Set<DetentSheetPresentationController.Detent>
    var preferredCornerRadius: CGFloat
    var prefersSwipeToDismiss: Bool
    @ViewBuilder var sheetContent: C
    
    @State private var detentSheetViewController: DetentSheetSwiftUIViewController<C>?
    @State private var transitionDelegate = DetentTransitionDelegate()
    @State private var isPresented: Bool = false

    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
                .onChange(of: selectedDetentIdentifier, perform: updatePresentation)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func updatePresentation(_ selectedDetentId: DetentSheetPresentationController.Detent.Identifier?) {
        guard selectedDetentId != nil else {
            detentSheetViewController?.dismiss(animated: true)
            isPresented = false
            return
        }
        if isPresented { return }
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }
        
        if #available(iOS 15.0, *) {
            guard let rootVC = windowScene.keyWindow?.rootViewController else { return }
            
            var presentingVC = rootVC
            while let presentedVC = presentingVC.presentedViewController {
                presentingVC = presentedVC
            }
            detentSheetViewController = DetentSheetSwiftUIViewController(
                detents: detents,
                preferredCornerRadius: preferredCornerRadius,
                prefersSwipeToDismiss: prefersSwipeToDismiss,
                selectedDetentIdentifier: $selectedDetentIdentifier,
                content: sheetContent
            )
            transitionDelegate.detents = detents
            
            detentSheetViewController?.transitioningDelegate = transitionDelegate
            detentSheetViewController?.modalPresentationStyle = .custom

            presentingVC.present(detentSheetViewController!, animated: true)
        } else {
            // Fallback on earlier versions
        }
        isPresented = true
    }
}
