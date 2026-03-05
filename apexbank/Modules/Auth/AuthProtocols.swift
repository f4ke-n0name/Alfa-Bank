protocol AuthViewInput {
    func render()
}

protocol AuthViewOutput {
    func viewDidLoad()
    func didTapLogin(email: String, password: String)
    func didTapRegister()
}

protocol AuthInteractorInput {
    func login(email: String, password: String) throws -> UserSession
    func restoreSession() throws -> UserSession?
}

protocol AuthRouterInput {
    func openCardList(session: UserSession)
    func openRegistration()
}
