import Foundation

class RegisterPresenter {
    weak var view: RegisterViewInput?
    var interactor: RegisterInteractorInput?
    var router: RegisterRouterInput?

    private var isLoading = false
}

extension RegisterPresenter: RegisterViewOutput {

    func viewDidLoad() {}

    func didTapRegister(firstName: String, lastName: String, email: String, password: String) {
        if isLoading {
            return
        }
        view?.clearErrors()

        var hasError = false

        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            view?.showFirstNameError("Введите имя")
            hasError = true
        }
        if lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            view?.showLastNameError("Введите фамилию")
            hasError = true
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
                let response = try self.interactor?.register(
                    firstName: firstName,
                    lastName: lastName,
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
                case .emailAlreadyTaken:
                    self.view?.showEmailError(error.localizedDescription)
                case .invalidEmailFormat:
                    self.view?.showEmailError(error.localizedDescription)
                case .passwordTooShort:
                    self.view?.showPasswordError(error.localizedDescription)
                case .emptyCredentials, .invalidCredentials, .sessionExpired:
                    self.view?.showError(error.localizedDescription)
                }
            } catch {
                self.view?.showError(error.localizedDescription)
            }
        }
    }

    func didTapBack() {
        router?.back()
    }

    func didChangeFirstName(_ value: String) {
        if let message = interactor?.validateName(value) {
            view?.showFirstNameError(message)
        } else {
            view?.showFirstNameError("")
        }
    }

    func didChangeLastName(_ value: String) {
        if let message = interactor?.validateName(value) {
            view?.showLastNameError(message)
        } else {
            view?.showLastNameError("")
        }
    }

    func didChangeEmail(_ value: String) {
        if let message = interactor?.validateEmail(value) {
            view?.showEmailError(message)
        } else {
            view?.showEmailError("")
        }
    }

    func didChangePassword(_ value: String) {
        if let message = interactor?.validatePassword(value) {
            view?.showPasswordError(message)
        } else {
            view?.showPasswordError("")
        }
    }
}
