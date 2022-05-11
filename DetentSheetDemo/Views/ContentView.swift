import SwiftUI
import DetentSheetPresentationController

struct ContentView: View {
    @State private var isPresenting: Bool = false
    
    var body: some View {
        Button("Show Sheet") {
            isPresenting = true
        }
        .detentSheet(
            isPresented: $isPresenting,
            detents: [.small(), .medium()]
        ) { PresentedView() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
