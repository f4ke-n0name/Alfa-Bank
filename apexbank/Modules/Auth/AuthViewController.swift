import UIKit

class AuthViewController: BDUIScreenContainerViewController {

    var output: AuthViewOutput?

    init(
        bduiModule: BDUIModuleInput
    ) {
        super.init(screen: .auth, bduiModule: bduiModule)
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
        setupLayout()
        setupActions()
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
    }

    private func configureScreenActionHandlers() {
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

extension AuthViewController: AuthViewInput {

    func render(_ model: AuthViewModel) {
        withView(id: "emailErrorLabel", as: DSErrorLabel.self) {
            $0.setMessage(model.emailState.errorMessage)
        }
        withView(id: "emailField", as: DSTextField.self) {
            $0.setError(model.emailState.hasError)
        }
        withView(id: "passwordErrorLabel", as: DSErrorLabel.self) {
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
        withView(id: "loginButton", as: DSButton.self) {
            $0.isEnabled = false
            $0.setTitleText("Вход...")
        }
    }

    private func hideLoading() {
        withView(id: "loginButton", as: DSButton.self) {
            $0.isEnabled = true
            $0.setTitleText("Войти")
        }
    }
}
