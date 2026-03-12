import Foundation

class AuthInteractor: AuthInteractorInput {

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func login(email: String, password: String) throws -> LoginResponse {
        let request = LoginRequest(email: email, password: password)
        return try repository.login(request: request)
    }

    func restoreSession() throws -> UserSession? {
        return nil
    }

    func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return nil
        }
        let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        let isValid = email.range(of: regex, options: .regularExpression) != nil
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
