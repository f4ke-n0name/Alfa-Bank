import UIKit

extension DS {
    enum Colors {
        static var primary: UIColor { DS.config.colors.primary }
        static var secondary: UIColor { DS.config.colors.secondary }
        static var background: UIColor { DS.config.colors.background }
        static var surface: UIColor { DS.config.colors.surface }
        static var textPrimary: UIColor { DS.config.colors.textPrimary }
        static var textSecondary: UIColor { DS.config.colors.textSecondary }
        static var error: UIColor { DS.config.colors.error }
        static var linkText: UIColor { DS.config.colors.linkText }
        static var cardBackground: UIColor { DS.config.colors.cardBackground }
    }
}

extension UIColor {
    convenience init(dynamicLight: UIColor, dark: UIColor) {
        self.init { trait in
            trait.userInterfaceStyle == .dark ? dark : dynamicLight
        }
    }
}
