protocol RegisterViewOutput: AnyObject {
    func viewDidLoad()
    func didTapRegister(firstName: String, lastName: String, email: String, password: String)
    func didTapBack()
    func didChangeFirstName(_ value: String)
    func didChangeLastName(_ value: String)
    func didChangeEmail(_ value: String)
    func didChangePassword(_ value: String)
}
