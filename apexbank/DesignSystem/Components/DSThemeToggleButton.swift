import UIKit

final class DSThemeToggleButton: UIButton {

    
    private var theme: AppTheme = ThemeManager.shared.currentTheme {
        didSet { applyThemeAppearance() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        applyBaseStyle()
        applyThemeAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyBaseStyle() {
        layer.cornerRadius = 16
        layer.masksToBounds = true

        backgroundColor = DS.Colors.surface
        tintColor = DS.Colors.primary

        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 32),
            heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func applyThemeAppearance() {
        
        switch theme {
        case .dark:
            setImage(UIImage(systemName: "moon.fill"), for: .normal)
        case .light:
            setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
        case .system:
            
            let isDarkNow = (traitCollection.userInterfaceStyle == .dark)
            setImage(UIImage(systemName: isDarkNow ? "moon.fill" : "sun.max.fill"), for: .normal)
        }
        imageView?.contentMode = .scaleAspectFit
    }

    @objc private func tapped() {
        
        let next: AppTheme
        switch ThemeManager.shared.currentTheme {
        case .dark:
            next = .light
        default:
            next = .dark
        }
        ThemeManager.shared.currentTheme = next
        theme = next
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if ThemeManager.shared.currentTheme == .system {
            applyThemeAppearance()
        }
    }
}
