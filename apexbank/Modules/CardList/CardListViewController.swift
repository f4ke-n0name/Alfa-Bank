import UIKit

class CardListViewController: UIViewController {

    var output: CardListViewOutput?

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return button
    }()

    private let tableManager = CardListTableManager()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Мои карты"

        setupNav()
        setupTable()
        setupOverlays()
        setupActions()

        output?.viewDidLoad()
    }

    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }

    private func setupTable() {
        tableManager.delegate = self
        tableManager.attach(to: tableView)

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

    private func setupOverlays() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(retryButton)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),

            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        activityIndicator.isHidden = true
        messageLabel.isHidden = true
        retryButton.isHidden = true
    }

    private func setupActions() {
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    @objc private func retryTapped() {
        output?.didTapRetry()
    }

    @objc private func refreshPulled() {
        output?.didPullToRefresh()
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
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            tableView.isHidden = true
            messageLabel.isHidden = true
            retryButton.isHidden = true

        case .loading:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            tableView.isHidden = true
            messageLabel.isHidden = true
            retryButton.isHidden = true

        case .content(let items):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            tableView.isHidden = false
            messageLabel.isHidden = true
            retryButton.isHidden = true
            tableManager.setItems(items)
            tableView.reloadData()

        case .empty:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            tableView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = "Пусто"
            retryButton.isHidden = true

        case .error(let message):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            tableView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = message
            retryButton.isHidden = false
        }
    }
}

extension CardListViewController: CardListTableManagerDelegate {
    func cardListTableManagerDidSelect(id: String) {
        output?.didSelectItem(id: id)
    }
}
