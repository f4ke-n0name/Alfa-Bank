protocol RegistrationViewInput {
    func render()
}

protocol RegistrationViewOutput {
    func viewDidLoad()
    func didChangeFirstName(_ name: String)
    func didChangeLastName(_ phone: String)
    func didChangeEmail(_ email: String)
    func didChangePassword(_ password: String)
    func didChangePasswordConfirm(_ confirm: String)
    func didTapRegister(fullName: String, phone: String, password: String)
    func didTapBackToAuth()
}

protocol RegistrationInteractorInput {
    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) throws -> UserSession
    func checkPhoneAvailability(_ phone: String) throws -> Bool
}

protocol RegistrationRouterInput {
    func openCardList(session: UserSession)
    func backToAuth()
}

enum PhoneValidationState: Equatable {
    case empty
    case available
    case taken
    case invalid
}
