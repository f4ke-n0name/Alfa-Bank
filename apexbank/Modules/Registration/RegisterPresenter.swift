import Foundation

final class RegisterPresenter {
    weak var view: RegisterViewInput?
    var interactor: RegisterInteractorInput?
    var router: RegisterRouterInput?

    private var isLoading = false
    private var formValues: [String: String] = [:]

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
        case "firstNameChanged":
            let value = context?["text"] ?? ""
            formValues["firstName"] = value
            let error = interactor?.validateName(value) ?? ""
            render(firstNameError: error)

        case "lastNameChanged":
            let value = context?["text"] ?? ""
            formValues["lastName"] = value
            let error = interactor?.validateName(value) ?? ""
            render(lastNameError: error)

        case "emailChanged":
            let value = context?["text"] ?? ""
            formValues["email"] = value
            let error = interactor?.validateEmail(value) ?? ""
            render(emailError: error)

        case "passwordChanged":
            let value = context?["text"] ?? ""
            formValues["password"] = value
            let error = interactor?.validatePassword(value) ?? ""
            render(passwordError: error)

        case "register":
            register()

        default:
            break
        }
    }

    private func handleRoute(target: String?) {
        if target == "back" {
            router?.back()
        }
    }

    private func register() {
        guard !isLoading else { return }

        let firstName = formValues["firstName"] ?? ""
        let lastName = formValues["lastName"] ?? ""
        let email = formValues["email"] ?? ""
        let password = formValues["password"] ?? ""
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
}
