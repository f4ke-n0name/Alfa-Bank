import UIKit

final class CardDetailViewController: UIViewController {

    private let viewModel: CardCellViewModel

    init(viewModel: CardCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let label: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "\(viewModel.cardType) | **** \(viewModel.lastFourDigits)"

        label.text =
        "Номер: \(viewModel.number)\n" +
        "Владелец: \(viewModel.cardholderName)\n" +
        "Баланс: \(viewModel.balance)\n" +
        "Срок: \(viewModel.expiryDate)"

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }
}
