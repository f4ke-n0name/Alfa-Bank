import UIKit

class AuthViewController: UIViewController {

    var output: AuthViewOutput?

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "ApexBank"
        l.font = .systemFont(ofSize: 32, weight: .bold)
        l.textAlignment = .center
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Войдите в аккаунт"
        l.font = .systemFont(ofSize: 17)
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        return l
    }()

    private let emailField = AuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let emailErrorLabel = AuthErrorLabel()

    private let passwordField = AuthTextField(placeholder: "Пароль", isSecure: true)
    private let passwordErrorLabel = AuthErrorLabel()

    private let passwordToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye"), for: .normal)
        btn.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        btn.tintColor = .secondaryLabel
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let errorBanner = AuthErrorBanner()

    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Войти"
        config.cornerStyle = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemBlue
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Нет аккаунта? Зарегистрироваться", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            emailField,
            emailErrorLabel,
            passwordField,
            passwordErrorLabel,
            errorBanner,
            loginButton,
            registerButton
        ])
        sv.axis = .vertical
        sv.spacing = 12
        sv.setCustomSpacing(4, after: emailField)
        sv.setCustomSpacing(4, after: passwordField)
        sv.setCustomSpacing(24, after: subtitleLabel)
        sv.setCustomSpacing(20, after: errorBanner)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupActions()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


    private func setupLayout() {
        view.addSubview(stackView)

        passwordField.addSubview(passwordToggleButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            loginButton.heightAnchor.constraint(equalToConstant: 52),

            passwordToggleButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            passwordToggleButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -14),
            passwordToggleButton.widthAnchor.constraint(equalToConstant: 28),
            passwordToggleButton.heightAnchor.constraint(equalToConstant: 28),
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        passwordToggleButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }


    @objc private func loginTapped() {
        view.endEditing(true)
        output?.didTapLogin(email: emailField.text ?? "", password: passwordField.text ?? "")
    }

    @objc private func registerTapped() {
        output?.didTapRegister()
    }

    @objc private func togglePassword() {
        passwordField.isSecureTextEntry.toggle()
        passwordToggleButton.isSelected = !passwordField.isSecureTextEntry
    }

    @objc private func emailChanged() {
        output?.didChangeEmail(emailField.text ?? "")
    }

    @objc private func passwordChanged() {
        output?.didChangePassword(passwordField.text ?? "")
    }
}


extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginTapped()
        }
        return true
    }
}

extension AuthViewController: AuthViewInput {

    func showLoading() {
        loginButton.isEnabled = false
        var config = loginButton.configuration
        config?.title = "Вход..."
        loginButton.configuration = config
    }

    func hideLoading() {
        loginButton.isEnabled = true
        var config = loginButton.configuration
        config?.title = "Войти"
        loginButton.configuration = config
    }

    func showError(_ message: String) {
        errorBanner.show(message)
    }

    func clearErrors() {
        errorBanner.hide()
        showEmailError("")
        showPasswordError("")
    }

    func showEmailError(_ message: String) {
        emailErrorLabel.show(message)
        emailField.setError(!message.isEmpty)
    }

    func showPasswordError(_ message: String) {
        passwordErrorLabel.show(message)
        passwordField.setError(!message.isEmpty)
    }
}
