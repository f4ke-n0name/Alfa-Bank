import UIKit

class RegisterViewController: UIViewController {

    var output: RegisterViewOutput?

    private let firstNameField = AuthTextField(placeholder: "Имя")
    private let firstNameError = AuthErrorLabel()
    private let lastNameField = AuthTextField(placeholder: "Фамилия")
    private let lastNameError = AuthErrorLabel()
    private let emailField = AuthTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let emailError = AuthErrorLabel()
    private let passwordField = AuthTextField(placeholder: "Пароль", isSecure: true)
    private let passwordError = AuthErrorLabel()
    private let errorBanner = AuthErrorBanner()

    private let registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Зарегистрироваться"
        config.cornerStyle = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemBlue
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            firstNameField, firstNameError,
            lastNameField,  lastNameError,
            emailField,     emailError,
            passwordField,  passwordError,
            errorBanner,
            registerButton
        ])
        sv.axis = .vertical
        sv.spacing = 12
        sv.setCustomSpacing(4, after: firstNameField)
        sv.setCustomSpacing(4, after: lastNameField)
        sv.setCustomSpacing(4, after: emailField)
        sv.setCustomSpacing(4, after: passwordField)
        sv.setCustomSpacing(20, after: errorBanner)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Регистрация"
        setupLayout()
        setupActions()
        output?.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupLayout() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }

    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        firstNameField.addTarget(self, action: #selector(firstNameChanged), for: .editingChanged)
        lastNameField.addTarget(self, action: #selector(lastNameChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        [firstNameField, lastNameField, emailField, passwordField].forEach { $0.delegate = self }
    }

    @objc private func registerTapped() {
        view.endEditing(true)
        output?.didTapRegister(
            firstName: firstNameField.text ?? "",
            lastName: lastNameField.text ?? "",
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }

    @objc private func firstNameChanged() { output?.didChangeFirstName(firstNameField.text ?? "") }
    @objc private func lastNameChanged() { output?.didChangeLastName(lastNameField.text ?? "") }
    @objc private func emailChanged() { output?.didChangeEmail(emailField.text ?? "") }
    @objc private func passwordChanged() { output?.didChangePassword(passwordField.text ?? "") }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fields: [AuthTextField] = [firstNameField, lastNameField, emailField, passwordField]
        if let tf = textField as? AuthTextField, let index = fields.firstIndex(of: tf), index < fields.count - 1 {
            fields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            registerTapped()
        }
        return true
    }
}

extension RegisterViewController: RegisterViewInput {

    func showLoading() {
        registerButton.isEnabled = false
        var config = registerButton.configuration
        config?.title = "Регистрация..."
        registerButton.configuration = config
    }

    func hideLoading() {
        registerButton.isEnabled = true
        var config = registerButton.configuration
        config?.title = "Зарегистрироваться"
        registerButton.configuration = config
    }

    func showError(_ message: String) { errorBanner.show(message) }

    func clearErrors() {
        errorBanner.hide()
        showFirstNameError(""); showLastNameError("")
        showEmailError(""); showPasswordError("")
    }

    func showFirstNameError(_ message: String) {
        firstNameError.show(message)
        firstNameField.setError(!message.isEmpty)
    }

    func showLastNameError(_ message: String) {
        lastNameError.show(message)
        lastNameField.setError(!message.isEmpty)
    }

    func showEmailError(_ message: String) {
        emailError.show(message)
        emailField.setError(!message.isEmpty)
    }

    func showPasswordError(_ message: String) {
        passwordError.show(message)
        passwordField.setError(!message.isEmpty)
    }
}
