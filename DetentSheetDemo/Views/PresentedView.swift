import SwiftUI
import DetentSheetPresentationController

struct PresentedView: View {
    @Binding var selectedDetentId: DetentSheetPresentationController.Detent.Identifier?
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                if selectedDetentId == .large {
                    Spacer()
                }
                Button(selectedDetentId?.rawValue.capitalized ?? "Dismiss") {
                    selectedDetentId = nil
                }
                .padding()
                
                Spacer()
            }
            Spacer()
        }
    }
}

struct PresentedView_Previews: PreviewProvider {
    static var previews: some View {
        PresentedView(selectedDetentId: .constant(.large))
    }
}
