protocol AuthInteractorInput: AnyObject {
    func login(email: String, password: String) throws -> LoginResponse
    func validateEmail(_ email: String) -> String?
    func validatePassword(_ password: String) -> String?
}
