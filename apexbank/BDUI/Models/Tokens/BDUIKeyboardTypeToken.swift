import UIKit

enum BDUIKeyboardTypeToken: String, Decodable {
    case `default`
    case email
    case numberPad
}

extension BDUIKeyboardTypeToken {
    func toUIKeyboardType() -> UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .email:
            return .emailAddress
        case .numberPad:
            return .numberPad
        }
    }
}
