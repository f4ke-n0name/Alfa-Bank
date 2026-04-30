import UIKit

class RegisterViewController: BDUIScreenContainerViewController {

    var output: RegisterViewOutput?

    init(
        bduiModule: BDUIModuleInput
    ) {
        super.init(screen: .register, bduiModule: bduiModule)
    }

    override func viewDidLoad() {
        configureAppearance()
        configureScreenActionHandlers()
        onAction = { [weak self] action in
            self?.output?.handle(action: action)
        }
        onScreenLoaded = { [weak self] in
            self?.output?.viewDidLoad()
        }
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

    private func configureAppearance() {
        view.backgroundColor = DS.Colors.background
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: DS.Colors.primary,
            .font: DS.Typography.title2()
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.hidesBackButton = true
    }

    private func configureScreenActionHandlers() {
        onEvent(named: "focusLastName") { [weak self] _ in
            self?.withView(id: "lastNameField", as: DSTextField.self) {
                $0.becomeFirstResponder()
            }
        }
        onEvent(named: "focusEmail") { [weak self] _ in
            self?.withView(id: "emailField", as: DSTextField.self) {
                $0.becomeFirstResponder()
            }
        }
        onEvent(named: "focusPassword") { [weak self] _ in
            self?.withView(id: "passwordField", as: DSTextField.self) {
                $0.becomeFirstResponder()
            }
        }
        onEvent(named: "toggleTheme") { _ in
            Self.toggleTheme()
        }
    }

    private static func toggleTheme() {
        let current = ThemeManager.shared.currentTheme
        ThemeManager.shared.currentTheme = (current == .dark) ? .light : .dark
    }
}

extension RegisterViewController: RegisterViewInput {

    func render(_ model: RegisterViewModel) {
        withView(id: "firstNameError", as: DSErrorLabel.self) {
            $0.setMessage(model.firstNameState.errorMessage)
        }
        withView(id: "firstNameField", as: DSTextField.self) {
            $0.setError(model.firstNameState.hasError)
        }
        withView(id: "lastNameError", as: DSErrorLabel.self) {
            $0.setMessage(model.lastNameState.errorMessage)
        }
        withView(id: "lastNameField", as: DSTextField.self) {
            $0.setError(model.lastNameState.hasError)
        }
        withView(id: "emailError", as: DSErrorLabel.self) {
            $0.setMessage(model.emailState.errorMessage)
        }
        withView(id: "emailField", as: DSTextField.self) {
            $0.setError(model.emailState.hasError)
        }
        withView(id: "passwordError", as: DSErrorLabel.self) {
            $0.setMessage(model.passwordState.errorMessage)
        }
        withView(id: "passwordField", as: DSTextField.self) {
            $0.setError(model.passwordState.hasError)
        }
        withView(id: "errorBanner", as: DSErrorBanner.self) {
            $0.setMessage(model.errorBanner)
        }

        model.isLoading ? showLoading() : hideLoading()
    }

    private func showLoading() {
        withView(id: "registerButton", as: DSButton.self) {
            $0.isEnabled = false
            $0.setTitleText("Регистрация...")
        }
    }

    private func hideLoading() {
        withView(id: "registerButton", as: DSButton.self) {
            $0.isEnabled = true
            $0.setTitleText("Зарегистрироваться")
        }
    }
}
