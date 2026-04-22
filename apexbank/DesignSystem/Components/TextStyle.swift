import UIKit

enum TextStyle {
    case title1
    case title2
    case body
    case button
    case caption
    case text12
    case error

    var font: UIFont {
        switch self {
        case .title1: return DS.Typography.title1()
        case .title2: return DS.Typography.title2()
        case .body: return DS.Typography.body()
        case .button: return DS.Typography.button()
        case .caption: return DS.Typography.caption()
        case .text12: return DS.Typography.text12()
        case .error: return DS.Typography.body()
        }
    }

    var color: UIColor {
        switch self {
        case .title1:
            return DS.Colors.primary
        case .error:
            return DS.Colors.error
        case .caption, .text12:
            return DS.Colors.textSecondary
        default:
            return DS.Colors.textPrimary
        }
    }
}

extension UILabel {
    func apply(_ style: TextStyle) {
        font = style.font
        textColor = style.color
    }
}
