protocol AuthViewOutput {
    func viewDidLoad()
    func didTapLogin(email: String, password: String)
    func didTapRegister()
    func didChangeEmail(_ email: String)
    func didChangePassword(_ password: String)
}
