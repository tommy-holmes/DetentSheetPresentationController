import Foundation

public extension DetentPresentationController {
    final class Detent: NSObject {
        var id: Identifier

        required init(_ id: Identifier) {
            self.id = id
        }

        public class func small() -> Self {
            return Self(.small)
        }
        public class func medium() -> Self {
            return Self(.medium)
        }
        public class func large() -> Self {
            return Self(.large)
        }
    }
}

extension DetentPresentationController.Detent {
    struct Identifier: @unchecked Sendable, Equatable, Hashable, RawRepresentable {
        let rawValue: String
    }
}

extension DetentPresentationController.Detent.Identifier {
    static let small: Self = .init(rawValue: "small")
    static let medium: Self = .init(rawValue: "medium")
    static let large: Self = .init(rawValue: "large")
}
