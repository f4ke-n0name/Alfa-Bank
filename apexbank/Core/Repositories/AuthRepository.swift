protocol AuthRepository {
    func login(request: LoginRequest) throws -> LoginResponse
    func loadSession(session: UserSession) throws
    func clearSession() throws
}
