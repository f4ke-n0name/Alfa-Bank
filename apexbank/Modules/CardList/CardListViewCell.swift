import UIKit

class CardListViewCell: UITableViewCell {
    static let reuseIdentifier = "CardListCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "chevron.right"))
        img.tintColor = DS.Colors.primary
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        accessoryView = nil
        backgroundColor = .clear
    }

    func configure(with model: CardCellViewModel) {
        titleLabel.text = "\(model.cardholderName)  \(model.lastFourDigits) | \(model.cardType)"
        subtitleLabel.text = "Срок: \(model.expiryDate)" + (model.isActive ? "" : " | Неактивна")
    }

    private func setup() {
        selectionStyle = .default
        backgroundColor = .clear
        let bg = UIView()
        bg.backgroundColor = DS.Colors.surface
        bg.layer.cornerRadius = DS.Spacing.cornerRadius
        bg.layer.masksToBounds = true
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
        contentView.backgroundColor = .clear

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = DS.Colors.surface
        container.layer.cornerRadius = DS.Spacing.cornerRadius
        container.layer.masksToBounds = true

        titleLabel.font = DS.Typography.title2()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = DS.Colors.textPrimary

        subtitleLabel.font = DS.Typography.text12()
        subtitleLabel.textColor = DS.Colors.primary
        subtitleLabel.numberOfLines = 1

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        container.addSubview(chevronImageView)
        contentView.addSubview(container)

        NSLayoutConstraint.activate([
    
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.s),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.s),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.m),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.m),

            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),

            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: DS.Spacing.m),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -DS.Spacing.m),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: DS.Spacing.m),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -DS.Spacing.m),

            chevronImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -DS.Spacing.m),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
    }
}
