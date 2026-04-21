import UIKit

final class DSStateView: UIView {
    enum State {
        case loading(text: String?)
        case empty(text: String?)
        case error(text: String, buttonTitle: String)
    }

    var onAction: (() -> Void)?

    private let stack = UIStackView()
    private let activity = UIActivityIndicatorView(style: .large)
    private let label = UILabel()
    private let button = DSButton(title: "")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = DS.Spacing.m
        stack.translatesAutoresizingMaskIntoConstraints = false

        label.numberOfLines = 0
        label.textAlignment = .center
        label.apply(.body)

        button.isHidden = true
        button.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)

        stack.addArrangedSubview(activity)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: DS.Spacing.l),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -DS.Spacing.l)
        ])
    }

    func render(_ state: State) {
        switch state {
        case .loading(let text):
            activity.isHidden = false
            activity.startAnimating()

            label.text = text
            label.apply(.body)
            label.textColor = DS.Colors.textSecondary

            button.isHidden = true

        case .empty(let text):
            activity.stopAnimating()
            activity.isHidden = true

            label.text = text ?? "Пусто"
            label.apply(.body)
            label.textColor = DS.Colors.textSecondary

            button.isHidden = true

        case .error(let text, let buttonTitle):
            activity.stopAnimating()
            activity.isHidden = true

            label.text = text
            label.apply(.body)
            label.textColor = DS.Colors.error

            button.setTitleText(buttonTitle)
            button.isHidden = false
        }
    }

    @objc private func actionTapped() {
        onAction?()
    }
}
