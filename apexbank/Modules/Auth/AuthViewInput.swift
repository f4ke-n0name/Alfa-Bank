protocol AuthViewInput: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func clearErrors()
    func showEmailError(_ message: String)
    func showPasswordError(_ message: String)
}
