import SwiftUI
import DetentSheetPresentationController

struct ContentView: View {
    @State private var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?
    
    var body: some View {
        Button("Show SwiftUI Sheet") {
            if selectedDetentIdentifier == nil {
                selectedDetentIdentifier = .small
            } else {
                print("Tap through")
            }
        }
        .detentSheet(
            selectedDetentIdentifier: $selectedDetentIdentifier,
            allowedDetents: [.small(), .medium(), .large()]
        ) {
            PresentedView(selectedDetentId: $selectedDetentIdentifier)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
