import Foundation

final class RegisterPresenter {
    weak var view: RegisterViewInput?
    var interactor: RegisterInteractorInput?
    var router: RegisterRouterInput?

    private var isLoading = false

    private func render(
        firstNameError: String = "",
        lastNameError: String = "",
        emailError: String = "",
        passwordError: String = "",
        banner: String = "",
        isLoading: Bool = false
    ) {
        let model = RegisterViewModel(
            firstNameState: RegisterFieldState(hasError: !firstNameError.isEmpty, errorMessage: firstNameError),
            lastNameState: RegisterFieldState(hasError: !lastNameError.isEmpty, errorMessage: lastNameError),
            emailState: RegisterFieldState(hasError: !emailError.isEmpty, errorMessage: emailError),
            passwordState: RegisterFieldState(hasError: !passwordError.isEmpty, errorMessage: passwordError),
            errorBanner: banner,
            isLoading: isLoading
        )
        view?.render(model)
    }
}

extension RegisterPresenter: RegisterViewOutput {

    func viewDidLoad() {}

    func didTapRegister(firstName: String, lastName: String, email: String, password: String) {
        guard !isLoading else { return }

        let firstNameError = firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Введите имя" : ""
        let lastNameError = lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Введите фамилию" : ""
        let emailError = email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Введите email" : ""
        let passwordError = password.isEmpty ? "Введите пароль" : ""

        if !firstNameError.isEmpty || !lastNameError.isEmpty || !emailError.isEmpty || !passwordError.isEmpty {
            render(
                firstNameError: firstNameError,
                lastNameError: lastNameError,
                emailError: emailError,
                passwordError: passwordError
            )
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
                case .emailAlreadyTaken, .invalidEmailFormat:
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

    func didTapBack() {
        router?.back()
    }

    func didChangeFirstName(_ value: String) {
        let error = interactor?.validateName(value) ?? ""
        render(firstNameError: error)
    }

    func didChangeLastName(_ value: String) {
        let error = interactor?.validateName(value) ?? ""
        render(lastNameError: error)
    }

    func didChangeEmail(_ value: String) {
        let error = interactor?.validateEmail(value) ?? ""
        render(emailError: error)
    }

    func didChangePassword(_ value: String) {
        let error = interactor?.validatePassword(value) ?? ""
        render(passwordError: error)
    }
}
