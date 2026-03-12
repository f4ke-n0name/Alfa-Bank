protocol RegisterViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func clearErrors()
    func showFirstNameError(_ message: String)
    func showLastNameError(_ message: String)
    func showEmailError(_ message: String)
    func showPasswordError(_ message: String)
}
