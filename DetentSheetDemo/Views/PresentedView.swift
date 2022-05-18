import SwiftUI
import DetentSheetPresentationController

struct PresentedView: View {
    @Binding var selectedDetentId: DetentSheetPresentationController.Detent.Identifier?
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Button(selectedDetentId?.rawValue.capitalized ?? "Dismiss") {
                    selectedDetentId = nil
                }
                .padding()
                
                Spacer()
            }
            Spacer()
        }
        .background(Color.red.edgesIgnoringSafeArea(.all))
    }
}

struct PresentedView_Previews: PreviewProvider {
    static var previews: some View {
        PresentedView(selectedDetentId: .constant(.large))
    }
}
