import UIKit

enum BDUIColorToken: String, Decodable {
    case primary
    case secondary
    case background
    case surface
    case textPrimary
    case textSecondary
    case error
    case linkText
    case cardBackground
}

extension BDUIColorToken{
    func toDSColor() -> UIColor {
        switch self {
        case .primary:
            return DS.Colors.primary
        case .secondary:
            return DS.Colors.secondary
        case .background:
            return DS.Colors.background
        case .surface:
            return DS.Colors.surface
        case .textPrimary:
            return DS.Colors.textPrimary
        case .textSecondary:
            return DS.Colors.textSecondary
        case .error:
            return DS.Colors.error
        case .cardBackground:
            return DS.Colors.cardBackground
        case .linkText:
            return DS.Colors.linkText
        }
    }
}
