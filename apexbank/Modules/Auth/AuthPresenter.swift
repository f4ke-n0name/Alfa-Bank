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
        if isLoading {
            return
        }

        view?.clearErrors()
        var hasError = false

        if email.isEmpty {
            view?.showEmailError("Введите email")
            hasError = true
        }
        if password.isEmpty {
            view?.showPasswordError("Введите пароль")
            hasError = true
        }
        if hasError {
            return
        }

        isLoading = true
        view?.showLoading()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            defer {
                self.isLoading = false
                self.view?.hideLoading()
            }
            do {
                let response = try self.interactor?.login(email: email, password: password)
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
                    self.view?.showError(error.localizedDescription)
                case .invalidEmailFormat:
                    self.view?.showEmailError(error.localizedDescription)
                case .passwordTooShort:
                    self.view?.showPasswordError(error.localizedDescription)
                case .emptyCredentials:
                    self.view?.showError(error.localizedDescription)
                case .emailAlreadyTaken, .sessionExpired:
                    self.view?.showError(error.localizedDescription)
                }
            } catch {
                self.view?.showError(error.localizedDescription)
            }
        }
    }

    func didTapRegister() {
        router?.openRegistration()
    }

    func didChangeEmail(_ email: String) {
        if let message = interactor?.validateEmail(email) {
            view?.showEmailError(message)
        } else {
            view?.showEmailError("")
        }
    }

    func didChangePassword(_ password: String) {
        if let message = interactor?.validatePassword(password) {
            view?.showPasswordError(message)
        } else {
            view?.showPasswordError("")
        }
    }
}
