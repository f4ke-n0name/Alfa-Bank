protocol RegistrationRepository {
    func register(request: RegisterRequest) throws -> LoginResponse
}
