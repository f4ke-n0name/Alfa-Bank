import UIKit

enum AppTheme: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2

    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }

    var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

final class ThemeManager {
    static let shared = ThemeManager()

    private let key = "apexbank.theme.selected"

    private init() {}

    var currentTheme: AppTheme {
        get {
            let raw = UserDefaults.standard.integer(forKey: key)
            return AppTheme(rawValue: raw) ?? .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
            apply(theme: newValue)
        }
    }

    func apply(theme: AppTheme) {
        let style = theme.interfaceStyle

        let scenes = UIApplication.shared.connectedScenes
        for scene in scenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = style
            }
        }
    }

    func applySavedTheme() {
        apply(theme: currentTheme)
    }
}
