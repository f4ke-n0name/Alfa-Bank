import UIKit

class CardListViewController: UIViewController {

    var output: CardListViewOutput?

    private var tableView = UITableView(frame: .zero, style: .plain)

    private var stateView: DSStateView = {
        var view = DSStateView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var tableManager = CardListTableManager()
    private var refreshControl = UIRefreshControl()

    private let themeToggle = DSThemeToggleButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Colors.background
        title = "Мои карты"

        setupNav()
        setupTable()
        setupStateView()
        setupActions()

        output?.viewDidLoad()
    }

    private func setupNav() {
        let backItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(logoutTapped))
        backItem.tintColor = DS.Colors.primary
        navigationItem.leftBarButtonItem = backItem

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: DS.Colors.primary,
            .font: DS.Typography.title2()
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: themeToggle)
    }

    private func setupTable() {
        tableManager.delegate = self
        tableManager.attach(to: tableView)

        tableView.backgroundColor = DS.Colors.background
        tableView.separatorColor = DS.Colors.secondary
        tableView.separatorStyle = .none
        tableView.cellLayoutMarginsFollowReadableWidth = false

        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupStateView() {
        view.addSubview(stateView)
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        stateView.onAction = { [weak self] in
            self?.output?.didRequestReload()
        }
    }

    private func setupActions() {
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
    }

    @objc private func refreshPulled() {
        output?.didRequestReload()
    }

    @objc private func logoutTapped() {
        output?.didTapLogout()
    }
}

extension CardListViewController: CardListViewInput {
    func render(_ state: CardListState) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }

        switch state {
        case .idle:
            stateView.isHidden = true
            tableView.isHidden = true

        case .loading:
            tableView.isHidden = true
            stateView.isHidden = false
            stateView.render(.loading(text: "Загрузка…"))

        case .content(let items):
            stateView.isHidden = true
            tableView.isHidden = false
            tableManager.setItems(items)
            tableView.reloadData()

        case .empty:
            tableView.isHidden = true
            stateView.isHidden = false
            stateView.render(.empty(text: "Пусто"))

        case .error(let message):
            tableView.isHidden = true
            stateView.isHidden = false
            stateView.render(.error(text: message, buttonTitle: "Повторить"))
        }
    }
}

extension CardListViewController: CardListTableManagerDelegate {
    func cardListTableManagerDidSelect(id: String) {
        output?.didSelectItem(id: id)
    }
}
