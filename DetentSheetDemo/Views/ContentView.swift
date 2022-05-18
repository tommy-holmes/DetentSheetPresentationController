import SwiftUI
import DetentSheetPresentationController

struct ContentView: View {
    @State private var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?
    
    var body: some View {
        Button("Show SwiftUI Sheet") {
            selectedDetentIdentifier = .small
        }
        .detentSheet(
            selectedDetentIdentifier: $selectedDetentIdentifier,
            allowedDetents: [.small(), .medium(), .large()]
        ) {
            PresentedView(selectedDetentId: $selectedDetentIdentifier)
        }
        .disabled(selectedDetentIdentifier != nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
