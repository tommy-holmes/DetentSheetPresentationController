# DetentSheetPresentationController

A backport for UIKit's `UISheetPresentationController` back to iOS 13+ as well as a wrapper for SwiftUI via a `ViewModifier`. 

Like Apple's implemention it has a `.large()` that is like a regular sheet and a `.medium()` detent that takes up **half** of the display, but unlike Apple's, this package has a _third_ detent: `.small()`, that takes up a **quater** of the display, similar to the sheet in Apple's Maps app. 

# How to use in UIKit

For presenting from a `UIViewController` you'll need to instantiate a custom `TransitioningDelegate` in the form of `DetentTransitionDelegate` (1)

> **NOTE:** 
> You will need to call it something _other_ than "transitioningDelegate" to avoid overriding the one that comes from `UIViewController` 

Then you can set your custom configs on the `transitionDelegate` (2) before setting it to the modal's `transitioningDelegate` (3) and calling `present`. 

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

https://user-images.githubusercontent.com/59975039/172373027-0992e088-fe64-4823-8f2e-e29417023d00.mp4

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
