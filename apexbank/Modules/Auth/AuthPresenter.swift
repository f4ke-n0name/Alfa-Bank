import Foundation

class AuthPresenter {
    weak var view: AuthViewInput?
    var interactor: AuthInteractorInput?
    var router: AuthRouterInput?

    private var isLoading = false
}

extension AuthPresenter: AuthViewOutput {

    func viewDidLoad() {}

    func didTapLogin(email: String, password: String) {
        guard !isLoading else { return }

        let emailError = email.isEmpty ? "Введите email" : ""
        let passwordError = password.isEmpty ? "Введите пароль" : ""

        if !emailError.isEmpty || !passwordError.isEmpty {
            render(emailError: emailError, passwordError: passwordError)
            return
        }

        isLoading = true
        render(isLoading: true)

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
                    self.render(banner: error.localizedDescription)
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
    
    func didTapRegister() {
        router?.openRegistration()
    }

    func didChangeEmail(_ email: String) {
        let error = interactor?.validateEmail(email) ?? ""
        render(emailError: error)
    }

    func didChangePassword(_ password: String) {
        let error = interactor?.validatePassword(password) ?? ""
        render(passwordError: error)
    }

    private func render(
        emailError: String = "",
        passwordError: String = "",
        banner: String = "",
        isLoading: Bool = false
    ) {
        let model = AuthViewModel(
            emailState: FieldState(
                text: "",
                hasError: !emailError.isEmpty,
                errorMessage: emailError
            ),
            passwordState: FieldState(
                text: "",
                hasError: !passwordError.isEmpty,
                errorMessage: passwordError
            ),
            errorBanner: banner,
            isLoading: isLoading
        )
        view?.render(model)
    }
}
