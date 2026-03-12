protocol RegisterInteractorInput: AnyObject {
    func register(firstName: String, lastName: String, email: String, password: String) throws -> LoginResponse
    func validateName(_ name: String) -> String?
    func validateEmail(_ email: String) -> String?
    func validatePassword(_ password: String) -> String?
}
