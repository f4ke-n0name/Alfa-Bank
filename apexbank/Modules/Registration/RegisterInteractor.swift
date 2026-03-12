import Foundation

class RegisterInteractor: RegisterInteractorInput {

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) throws -> LoginResponse {
        let request = RegisterRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            notMaskedPassword: password
        )
        return try repository.register(request: request)
    }

    func validateName(_ name: String) -> String? {
        if name.isEmpty {
            return nil
        }
        return name.count >= 3 ? nil : "Минимум 3 символа"
    }

    func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return nil
        }
        let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(
            with: email
        )
        return isValid ? nil : AuthError.invalidEmailFormat.errorDescription
    }

    func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return nil
        }
        return password.count >= 6
            ? nil : AuthError.passwordTooShort.errorDescription
    }
}
