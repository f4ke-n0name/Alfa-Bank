import UIKit

final class CardListStubViewController: UIViewController {

    private let session: UserSession

    init(session: UserSession) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    private let label: UILabel = {
        let l = UILabel()
        l.text = "Вы вошли!"
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Мои карты"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func logoutTapped() {
        navigationController?.setViewControllers(
            [AuthModule.build()],
            animated: true
        )
    }
}
