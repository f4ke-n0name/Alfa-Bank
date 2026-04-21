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

    private let cardView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = DS.Colors.cardBackground
        v.layer.cornerRadius = DS.Spacing.cornerRadius
        v.layer.masksToBounds = true
        return v
    }()

    private let brandLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "ApexBank"
        l.apply(.title1)
        l.textColor = DS.Colors.primary
        l.setContentCompressionResistancePriority(.required, for: .horizontal)
        return l
    }()

    private let numberLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.apply(.caption)
        l.textColor = DS.Colors.textPrimary
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.7
        return l
    }()

    private let holderLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.apply(.caption)
        l.textColor = DS.Colors.textPrimary
        l.numberOfLines = 1
        return l
    }()

    private let expiryLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.apply(.caption)
        l.textColor = DS.Colors.textPrimary
        l.numberOfLines = 1
        return l
    }()

    private let visaLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "VISA"
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.textColor = .white
        l.textAlignment = .right
        return l
    }()

    private let balanceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.apply(.caption)
        l.textColor = DS.Colors.textPrimary
        l.textAlignment = .center
        l.numberOfLines = 1
        return l
    }()

    private let themeToggle = DSThemeToggleButton()

    private lazy var contentStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cardView, balanceLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = DS.Spacing.m
        return sv
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Colors.background

        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: DS.Colors.primary,
            .font: DS.Typography.title2()
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "\(viewModel.cardType) | **** \(viewModel.lastFourDigits)"

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: themeToggle)

        setupLayout()
        applyViewModel()
    }

    

    private func setupLayout() {
        view.addSubview(contentStack)

        cardView.addSubview(brandLabel)
        cardView.addSubview(numberLabel)
        cardView.addSubview(holderLabel)
        cardView.addSubview(expiryLabel)
        cardView.addSubview(visaLabel)

        
        let cardAspectRatio: CGFloat = 1.586

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),

            cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 1.0 / cardAspectRatio),

            
            brandLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DS.Spacing.m),
            brandLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.m),
            brandLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -DS.Spacing.m),

            
            numberLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: DS.Spacing.s),
            numberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.m),
            numberLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DS.Spacing.m),

            
            holderLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.m),
            holderLabel.bottomAnchor.constraint(equalTo: expiryLabel.topAnchor, constant: -4),
            holderLabel.trailingAnchor.constraint(lessThanOrEqualTo: visaLabel.leadingAnchor, constant: -DS.Spacing.m),

            expiryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DS.Spacing.m),
            expiryLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DS.Spacing.m),
            expiryLabel.trailingAnchor.constraint(lessThanOrEqualTo: visaLabel.leadingAnchor, constant: -DS.Spacing.m),

            
            visaLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DS.Spacing.m),
            visaLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DS.Spacing.m),

            
            balanceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])
    }

    private func applyViewModel() {
        numberLabel.text = groupedNumber(viewModel.number)
        holderLabel.text = viewModel.cardholderName
        expiryLabel.text = viewModel.expiryDate
        balanceLabel.text = "Баланс : \(viewModel.balance)"

        
        
    }

    private func groupedNumber(_ raw: String) -> String {
        let digits = raw.filter { $0.isNumber }
        var padded = digits
        while padded.count < 16 { padded = "0" + padded }
        return stride(from: 0, to: 16, by: 4).map { idx in
            let start = padded.index(padded.startIndex, offsetBy: idx)
            let end = padded.index(start, offsetBy: 4)
            return String(padded[start..<end])
        }.joined(separator: " ")
    }
}
