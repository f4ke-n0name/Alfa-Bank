import Foundation

class AuthPresenter {
    weak var view: AuthViewInput?
    var interactor: AuthInteractorInput?
    var router: AuthRouterInput?

    private var isLoading = false
    private var currentEmailError = ""
    private var currentPasswordError = ""
    private var currentBanner = ""
    private var formValues: [String: String] = [:]
}

extension AuthPresenter: AuthViewOutput {

    func viewDidLoad() {}

    func handle(action: BDUIAction) {
        switch action.type {
        case .event:
            handleEvent(name: action.name, context: action.context)
        case .route:
            handleRoute(target: action.target)
        case .reload:
            break
        }
    }

    private func handleEvent(name: String?, context: [String: String]?) {
        switch name {
        case "emailChanged":
            let email = context?["text"] ?? ""
            formValues["email"] = email
            let error = interactor?.validateEmail(email) ?? ""
            render(emailError: error, banner: "")

        case "passwordChanged":
            let password = context?["text"] ?? ""
            formValues["password"] = password
            let error = interactor?.validatePassword(password) ?? ""
            render(passwordError: error, banner: "")

        case "login":
            login()

        default:
            break
        }
    }

    private func handleRoute(target: String?) {
        if target == "registration" {
            router?.openRegistration()
        }
    }

    private func login() {
        guard !isLoading else { return }

        let email = formValues["email"] ?? ""
        let password = formValues["password"] ?? ""
        let emailError = email.isEmpty ? "Введите email" : ""
        let passwordError = password.isEmpty ? "Введите пароль" : ""

        if !emailError.isEmpty || !passwordError.isEmpty {
            render(emailError: emailError, passwordError: passwordError)
            return
        }

        isLoading = true
        render(
            emailError: "",
            passwordError: "",
            banner: "",
            isLoading: true
        )

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            defer {
                self.isLoading = false
                self.render(isLoading: false)
            }
            do {
                let response = try self.interactor?.login(
                    email: email,
                    password: password
                )
                if let response {
                    let session = UserSession(
                        token: response.token,
                        userId: response.userId,
                        expiresAt: response.expiresAt
                    )
                    self.router?.openCardList(session: session)
                }
            } catch let error as AuthError {
                switch error {
                case .invalidCredentials:
                    self.render(
                        emailError: "Неверный email или пароль",
                        passwordError: "Неверный email или пароль",
                        banner: error.localizedDescription
                    )
                case .invalidEmailFormat:
                    self.render(emailError: error.localizedDescription)
                case .passwordTooShort:
                    self.render(passwordError: error.localizedDescription)
                default:
                    self.render(banner: error.localizedDescription)
                }
            } catch {
                self.render(banner: error.localizedDescription)
            }
        }
    }

    private func render(
        emailError: String? = nil,
        passwordError: String? = nil,
        banner: String? = nil,
        isLoading: Bool? = nil
    ) {
        if let emailError {
            currentEmailError = emailError
        }
        if let passwordError {
            currentPasswordError = passwordError
        }
        if let banner {
            currentBanner = banner
        }
        if let isLoading {
            self.isLoading = isLoading
        }

        let model = AuthViewModel(
            emailState: FieldState(
                text: "",
                hasError: !currentEmailError.isEmpty,
                errorMessage: currentEmailError
            ),
            passwordState: FieldState(
                text: "",
                hasError: !currentPasswordError.isEmpty,
                errorMessage: currentPasswordError
            ),
            errorBanner: currentBanner,
            isLoading: self.isLoading
        )
        view?.render(model)
    }
}
