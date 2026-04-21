import UIKit

final class DSTextField: UITextField {

    init(
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false
    ) {
        super.init(frame: .zero)

        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure

        autocapitalizationType = .none
        autocorrectionType = .no
        borderStyle = .none
        font = DS.Typography.body()
        textColor = DS.Colors.textPrimary
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = DS.Spacing.cornerRadius
        layer.borderWidth = 1
        layer.borderColor = DS.Colors.secondary.cgColor
        backgroundColor = DS.Colors.surface

        let padding = UIView(frame: CGRect(x: 0, y: 0, width: DS.Spacing.m, height: 0))
        leftView = padding
        leftViewMode = .always

        rightViewMode = .always
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setError(_ hasError: Bool) {
        layer.borderColor = (hasError ? DS.Colors.error : DS.Colors.secondary).cgColor
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 50)
    }
}

final class DSErrorLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        apply(.text12)
        textColor = DS.Colors.error
        numberOfLines = 0
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setMessage(_ message: String?) {
        text = message
        isHidden = (message?.isEmpty ?? true)
    }
}

final class DSErrorBanner: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        apply(.body)
        textColor = DS.Colors.textPrimary
        textAlignment = .center
        numberOfLines = 0
        backgroundColor = DS.Colors.error
        layer.cornerRadius = DS.Spacing.cornerRadius
        layer.masksToBounds = true
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setMessage(_ message: String?) {
        if let message, !message.isEmpty {
            text = "  \(message)  "
            isHidden = false
        } else {
            text = nil
            isHidden = true
        }
    }
}
