import Foundation

public extension DetentSheetPresentationController {
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

public extension DetentSheetPresentationController.Detent {
    struct Identifier: @unchecked Sendable, Equatable, Hashable, RawRepresentable {
        public var rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

public extension DetentSheetPresentationController.Detent.Identifier {
    static let small: Self = .init("small")
    static let medium: Self = .init("medium")
    static let large: Self = .init("large")
}
