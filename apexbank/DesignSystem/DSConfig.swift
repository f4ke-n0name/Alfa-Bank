import UIKit



struct DSConfig {
    let colors: Colors
    let typography: Typography
    let spacing: Spacing

    struct Colors {
        let primary: UIColor
        let secondary: UIColor
        let background: UIColor
        let surface: UIColor
        let textPrimary: UIColor
        let textSecondary: UIColor
        let error: UIColor
        let linkText: UIColor
        let cardBackground: UIColor
    }

    struct Typography {
        let title1: UIFont
        let title2: UIFont
        let body: UIFont
        let button: UIFont
        let caption: UIFont
        let text12: UIFont
    }

    struct Spacing {
        let xs: CGFloat
        let s: CGFloat
        let m: CGFloat
        let l: CGFloat
        let xl: CGFloat
        let cornerRadius: CGFloat
    }

    static let `default`: DSConfig = DSConfig(
        colors: .init(
            primary: DSColors.primary,
            secondary: DSColors.secondary,
            background: DSColors.background,
            surface: DSColors.surface,
            textPrimary: DSColors.textPrimary,
            textSecondary: DSColors.textSecondary,
            error: DSColors.error,
            linkText: DSColors.linkText,
            cardBackground: DSColors.cardBackground
        ),
        typography: .init(
            title1: DSTypography.title1(),
            title2: DSTypography.title2(),
            body: DSTypography.body(),
            button: DSTypography.button(),
            caption: DSTypography.caption(),
            text12: DSTypography.text12()
        ),
        spacing: .init(
            xs: DSSpacing.xs,
            s: DSSpacing.s,
            m: DSSpacing.m,
            l: DSSpacing.l,
            xl: DSSpacing.xl,
            cornerRadius: DSSpacing.cornerRadius
        )
    )
}
