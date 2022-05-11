import SwiftUI

public extension View {
    func detentSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [DetentSheetPresentationController.Detent],
        preferedCornerRadius: CGFloat = 13,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            DetentSheetModifier(
                isPresented: isPresented,
                detents: detents,
                preferedCornerRadius: preferedCornerRadius,
                sheetContent: content
            )
        )
    }
}

private struct DetentSheetModifier<C: View>: ViewModifier {
    @Binding var isPresented: Bool
    var detents: [DetentSheetPresentationController.Detent]
    var preferedCornerRadius: CGFloat
    @ViewBuilder var sheetContent: C

    func body(content: Content) -> some View {
        DetentSheetView(
            isPresented: $isPresented,
            detents: detents,
            preferredCornerRadius: preferedCornerRadius
        ) { sheetContent }
    }
}
