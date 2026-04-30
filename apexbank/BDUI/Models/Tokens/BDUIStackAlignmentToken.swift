import UIKit

enum BDUIStackAlignmentToken: String, Decodable {
    case fill
    case leading
    case center
    case trailing
}

extension BDUIStackAlignmentToken {
    func toUIStackViewAlignment() -> UIStackView.Alignment {
        switch self {
        case .fill:
            return .fill
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
}
