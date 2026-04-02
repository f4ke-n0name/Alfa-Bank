protocol CardListViewOutput: AnyObject {
    func viewDidLoad()
    func didTapRetry()
    func didPullToRefresh()
    func didSelectItem(id: String)
    func didTapLogout()
}
