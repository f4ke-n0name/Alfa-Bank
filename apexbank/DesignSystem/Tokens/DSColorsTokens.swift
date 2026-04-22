import UIKit



enum DSColors {
    static let primary = UIColor(hex: "#CD2062FF")
    static let secondary = UIColor(hex: "#D1D1D1FF")
    static let error = UIColor(hex: "#FF4D4DFF")
    static let linkText = UIColor(hex: "#0073FFFF")

    static let background = UIColor(
        dynamicLight: UIColor(hex: "#FEFFFFFF"),
        dark: UIColor(hex: "#0E0E0EFF")
    )

    static let surface = UIColor(
        dynamicLight: UIColor(hex: "#C6C6C6FF"),
        dark: UIColor(hex: "#3C3A3AFF")
    )

    static let textPrimary = UIColor(
        dynamicLight: UIColor(hex: "#0E0E0EFF"),
        dark: UIColor(hex: "#FEFFFFFF")
    )

    static let textSecondary = UIColor(
        dynamicLight: UIColor(hex: "#6D6D6DFF"),
        dark: UIColor(hex: "#C3C3C3FF")
    )

    static let cardBackground = UIColor(hex: "#CA9842FF")
    static let cardText = UIColor(hex: "#625D5DFF")
}
