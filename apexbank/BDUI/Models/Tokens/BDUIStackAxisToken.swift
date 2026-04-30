import UIKit

enum BDUIStackAxisToken: String, Decodable {
    case vertical
    case horizontal
}

extension BDUIStackAxisToken {
    func toUIAxis() -> NSLayoutConstraint.Axis {
        switch self {
        case .vertical:
            return .vertical
        case .horizontal:
            return .horizontal
        }
    }
}
