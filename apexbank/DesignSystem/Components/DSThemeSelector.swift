import UIKit

final class DSThemeSelector: UIView {

    var onChange: ((AppTheme) -> Void)?

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: AppTheme.allCases.map { $0.title })
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        segmentedControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        applyDS()
        setSelectedTheme(ThemeManager.shared.currentTheme)
    }

    func setSelectedTheme(_ theme: AppTheme) {
        segmentedControl.selectedSegmentIndex = theme.rawValue
    }

    private func applyDS() {
        
        segmentedControl.selectedSegmentTintColor = DS.Colors.primary
        segmentedControl.backgroundColor = DS.Colors.surface

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: DS.Typography.text12(),
            .foregroundColor: DS.Colors.textPrimary
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: DS.Typography.text12(),
            .foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    }

    @objc private func valueChanged() {
        let theme = AppTheme(rawValue: segmentedControl.selectedSegmentIndex) ?? .system
        onChange?(theme)
    }
}
