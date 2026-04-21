protocol CardListViewOutput: AnyObject {
    func viewDidLoad()
    func didRequestReload()
    func didSelectItem(id: String)
    func didTapLogout()
}
