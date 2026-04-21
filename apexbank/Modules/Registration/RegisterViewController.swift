import UIKit

class RegisterViewController: UIViewController {

    var output: RegisterViewOutput?

    private let firstNameField = DSTextField(placeholder: "Имя")
    private let firstNameError = DSErrorLabel()
    private let lastNameField = DSTextField(placeholder: "Фамилия")
    private let lastNameError = DSErrorLabel()
    private let emailField = DSTextField(
        placeholder: "Email",
        keyboardType: .emailAddress
    )
    private let emailError = DSErrorLabel()
    private let passwordField = DSTextField(
        placeholder: "Пароль",
        isSecure: true
    )
    private let passwordError = DSErrorLabel()
    private let errorBanner = DSErrorBanner()

    private let registerButton = DSButton(title: "Зарегистрироваться")

    private let themeToggle = DSThemeToggleButton()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            firstNameField, firstNameError,
            lastNameField, lastNameError,
            emailField, emailError,
            passwordField, passwordError,
            errorBanner,
            registerButton,
        ])
        sv.axis = .vertical
        sv.spacing = DS.Spacing.cornerRadius
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
        view.backgroundColor = DS.Colors.background
        let brandLabel = UILabel()
        brandLabel.text = "ApexBank"
        brandLabel.textAlignment = .center
        brandLabel.textColor = DS.Colors.primary
        brandLabel.apply(.title1)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandLabel)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: DS.Colors.primary,
            .font: DS.Typography.title2()
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: themeToggle)

        setupLayout()
        setupActions()
        output?.viewDidLoad()

        NSLayoutConstraint.activate([
            brandLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DS.Spacing.l),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            brandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: brandLabel.bottomAnchor, constant: DS.Spacing.m)
        ])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupLayout() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),
            registerButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }

    private func setupActions() {
        registerButton.addTarget(
            self,
            action: #selector(registerTapped),
            for: .touchUpInside
        )
        firstNameField.addTarget(
            self,
            action: #selector(firstNameChanged),
            for: .editingChanged
        )
        lastNameField.addTarget(
            self,
            action: #selector(lastNameChanged),
            for: .editingChanged
        )
        emailField.addTarget(
            self,
            action: #selector(emailChanged),
            for: .editingChanged
        )
        passwordField.addTarget(
            self,
            action: #selector(passwordChanged),
            for: .editingChanged
        )
        [firstNameField, lastNameField, emailField, passwordField].forEach {
            $0.delegate = self
        }
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

    @objc private func firstNameChanged() {
        output?.didChangeFirstName(firstNameField.text ?? "")
    }
    @objc private func lastNameChanged() {
        output?.didChangeLastName(lastNameField.text ?? "")
    }
    @objc private func emailChanged() {
        output?.didChangeEmail(emailField.text ?? "")
    }
    @objc private func passwordChanged() {
        output?.didChangePassword(passwordField.text ?? "")
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fields: [DSTextField] = [
            firstNameField, lastNameField, emailField, passwordField,
        ]
        if let tf = textField as? DSTextField,
            let index = fields.firstIndex(of: tf), index < fields.count - 1
        {
            fields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            registerTapped()
        }
        return true
    }
}

extension RegisterViewController: RegisterViewInput {

    func render(_ model: RegisterViewModel) {
        firstNameError.setMessage(model.firstNameState.errorMessage)
        firstNameField.setError(model.firstNameState.hasError)

        lastNameError.setMessage(model.lastNameState.errorMessage)
        lastNameField.setError(model.lastNameState.hasError)

        emailError.setMessage(model.emailState.errorMessage)
        emailField.setError(model.emailState.hasError)

        passwordError.setMessage(model.passwordState.errorMessage)
        passwordField.setError(model.passwordState.hasError)

        errorBanner.setMessage(model.errorBanner)

        model.isLoading ? showLoading() : hideLoading()
    }

    private func showLoading() {
        registerButton.isEnabled = false
        registerButton.setTitleText("Регистрация...")
    }

    private func hideLoading() {
        registerButton.isEnabled = true
        registerButton.setTitleText("Зарегистрироваться")
    }
}
