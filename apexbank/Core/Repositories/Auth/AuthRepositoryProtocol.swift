protocol AuthRepositoryProtocol {
    func register(request: RegisterRequest) throws -> LoginResponse
    func login(request: LoginRequest) throws -> LoginResponse
    func loadSession(session: UserSession) throws
    func clearSession() throws
    
}
