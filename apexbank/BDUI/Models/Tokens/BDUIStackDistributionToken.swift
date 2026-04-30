import UIKit

enum BDUIStackDistributionToken: String, Decodable {
    case fill
    case fillEqually
    case equalSpacing
}

extension BDUIStackDistributionToken {
    func toUIStackViewDistribution() -> UIStackView.Distribution {
        switch self {
        case .fill:
            return .fill
        case .fillEqually:
            return .fillEqually
        case .equalSpacing:
            return .equalSpacing
        }
    }
}
