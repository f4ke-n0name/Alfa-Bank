import UIKit

class AuthTextField: UITextField {

    init(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.borderStyle = .none
        self.font = .systemFont(ofSize: 16)
        self.translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
        backgroundColor = .secondarySystemBackground

        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        leftView = padding
        leftViewMode = .always
    }

    required init?(coder: NSCoder) { fatalError() }

    func setError(_ hasError: Bool) {
        layer.borderColor = (hasError ? UIColor.systemRed : UIColor.separator).cgColor
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 50)
    }
}

final class AuthErrorLabel: UILabel {

    init() {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 12)
        textColor = .systemRed
        numberOfLines = 0
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) { fatalError() }

    func show(_ message: String) {
        text = message
        isHidden = message.isEmpty
    }
}

final class AuthErrorBanner: UILabel {

    init() {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 14, weight: .medium)
        textColor = .white
        textAlignment = .center
        numberOfLines = 0
        backgroundColor = .systemRed
        layer.cornerRadius = 10
        layer.masksToBounds = true
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) { fatalError() }

    func show(_ message: String) {
        text = "  \(message)  "
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
