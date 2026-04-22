import UIKit

class AuthViewController: UIViewController {

    var output: AuthViewOutput?

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "ApexBank"
        l.textAlignment = .center
        l.apply(.title1)
        l.textColor = DS.Colors.primary
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Войдите в аккаунт"
        l.textAlignment = .center
        l.apply(.title2)
        l.textColor = DS.Colors.textSecondary
        return l
    }()

    private let emailField = DSTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let emailErrorLabel = DSErrorLabel()

    private let passwordField = DSTextField(placeholder: "Пароль", isSecure: true)
    private let passwordErrorLabel = DSErrorLabel()

    private let passwordToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye"), for: .normal)
        btn.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        btn.tintColor = DS.Colors.textSecondary
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let errorBanner = DSErrorBanner()

    private let loginButton = DSButton(title: "Войти")

    private let registerButton = DSButton(title: "Нет аккаунта? Зарегистрироваться")

    private let themeToggle = DSThemeToggleButton()

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
        sv.spacing = 16

        sv.setCustomSpacing(24, after: subtitleLabel)
        sv.setCustomSpacing(8, after: emailField)
        sv.setCustomSpacing(8, after: passwordField)
        sv.setCustomSpacing(16, after: errorBanner)

        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Colors.background

        // Ensure navigation title style uses title2
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: DS.Colors.primary,
            .font: DS.Typography.title2()
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: themeToggle)

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
            // 🔥 вместо center — нормальный layout
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -40),

            // 🔥 высоты как в макете
            emailField.heightAnchor.constraint(equalToConstant: 52),
            passwordField.heightAnchor.constraint(equalToConstant: 52),
            loginButton.heightAnchor.constraint(equalToConstant: 52),


            // eye button
            passwordToggleButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            passwordToggleButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -14),
            passwordToggleButton.widthAnchor.constraint(equalToConstant: 28),
            passwordToggleButton.heightAnchor.constraint(equalToConstant: 28),
        ])

        registerButton.titleLabel?.numberOfLines = 0
        registerButton.titleLabel?.textAlignment = .center
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

    func render(_ model: AuthViewModel) {
        emailErrorLabel.setMessage(model.emailState.errorMessage)
        emailField.setError(model.emailState.hasError)

        passwordErrorLabel.setMessage(model.passwordState.errorMessage)
        passwordField.setError(model.passwordState.hasError)

        errorBanner.setMessage(model.errorBanner)

        model.isLoading ? showLoading() : hideLoading()
    }

    private func showLoading() {
        loginButton.isEnabled = false
        loginButton.setTitleText("Вход...")
    }

    private func hideLoading() {
        loginButton.isEnabled = true
        loginButton.setTitleText("Войти")
    }
}
