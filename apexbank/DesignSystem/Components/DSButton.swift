import UIKit

final class DSButton: UIButton {
    enum Size {
        case regular
    }

    private let size: Size

    init(title: String, size: Size = .regular) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupAppearance()
        setTitle(title, for: .normal)
        setupStates()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setTitleText(_ title: String) {
        setTitle(title, for: .normal)
    }

    private func setupAppearance() {
        layer.cornerRadius = DS.Spacing.cornerRadius
        titleLabel?.font = DS.Typography.button()

        backgroundColor = DS.Colors.primary
        setTitleColor(.white, for: .normal)

        contentEdgeInsets = UIEdgeInsets(
            top: DS.Spacing.s,
            left: DS.Spacing.m,
            bottom: DS.Spacing.s,
            right: DS.Spacing.m
        )
    }

    private func setupStates() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }

    @objc private func touchDown() {
        animate(scale: 0.96, alpha: 0.8)
    }

    @objc private func touchUp() {
        animate(scale: 1.0, alpha: 1.0)
    }

    private func animate(scale: CGFloat, alpha: CGFloat) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.alpha = alpha
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.4
        }
    }

    override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        let width = base.width + contentEdgeInsets.left + contentEdgeInsets.right
        let height = max(44, base.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
        return CGSize(width: width, height: height)
    }
}
