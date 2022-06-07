# DetentSheetPresentationController

A backport for UIKit's `UISheetPresentationController` back to iOS 13+ as well as a wrapper for SwiftUI via a `ViewModifier`. 

# How to use in UIKit

For presenting from a `UIViewController` you'll need to instantiate a custom `TransitioningDelegate` in the form of `DetentTransitionDelegate` (1)

> **_NOTE:_** You will need to call it something _other_ than "transitioningDelegate" to avoid overriding the one that comes from `UIViewController` 

Then you can set your custom configs on the `transitionDelegate` before setting it to the modal's `transitioningDelegate` (3) and calling `present`. 

```swift
final class ViewController: UIViewController {
    // 1
    lazy var transitionDelegate = DetentTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showSheet(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sheetVC = storyboard.instantiateViewController(identifier: "ShownVC")
        // 2
        transitionDelegate.detents = [.small(), .medium(), .large()]
        // 3
        sheetVC.transitioningDelegate = transitionDelegate
        sheetVC.modalPresentationStyle = .custom
        
        present(sheetVC, animated: true)
    }
    
}
```

For the `UIViewController` that is being presented you'll need to do some set up if you want it to have knowlege of the `currentDetent`:
1. Cast its `presentationController` to `DetentSheetPresentationController`.
2. Set the `presentationController.detentDelegate` to `self` and confrom the `UIViewController` to `DetentSheetPresentationControllerDelegate`.
3. The `detentDelegate` has a method called `detentSheetPresentationControllerDidChangeSelectedDetentIdentifier` that is called everytime the `selectedDetentIdentifier` is changed. 
    
```swift
final class ShownViewController: UIViewController, DetentSheetPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        let presentationController = presentationController as? DetentSheetPresentationController
        // 2
        presentationController?.detentDelegate = self
    }
    // 3
    func detentSheetPresentationControllerDidChangeSelectedDetentIdentifier(_ detentSheetPresentationController: DetentSheetPresentationController) {
        guard let currentDetent = detentSheetPresentationController.selectedDetentIdentifier else { return }
    }
}
```

# How to use in SwiftUI

In SwiftUI there is a `ViewModifier` called `.detentSheet` that you can power via a `State` change using the `selectedDetentIdentifier`:
1. Create a `State` for `DetentSheetPresentationController.Detent.Identifier?` so that when you give it a value it presents the `detentSheet` to that size. 
2. You can set all your configs in the arguments for the `.detentSheet` such as `allowedDentents`. 
3. You can then pass in the `selectedDetentId` via a `Binding` so that the presented view has knowlege of it's current detent and can set it to `nil` when it wants to be dismissed. 

```swift
struct ContentView: View {
    // 1
    @State private var selectedDetentIdentifier: DetentSheetPresentationController.Detent.Identifier?
    
    var body: some View {
        Button("Show SwiftUI Sheet") {
            selectedDetentIdentifier = .small
        }
        // 2
        .detentSheet(
            selectedDetentIdentifier: $selectedDetentIdentifier,
            allowedDetents: [.small(), .medium(), .large()]
        ) {
            // 3
            PresentedView(selectedDetentId: $selectedDetentIdentifier)
        }
    }
}
```

# Installing this package