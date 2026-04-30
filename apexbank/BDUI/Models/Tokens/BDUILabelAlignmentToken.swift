import UIKit

enum BDUILabelAlignmentToken: String, Decodable {
    case left
    case center
    case right
    case natural
}

extension BDUILabelAlignmentToken {
    func toNSTextAlignment() -> NSTextAlignment {
        switch self {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        case .natural:
            return .natural
        }
    }
}
