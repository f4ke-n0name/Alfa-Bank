import UIKit

class CardListTableManager: NSObject {
    weak var delegate: CardListTableManagerDelegate?

    private var items: [CardCellViewModel] = []

    func attach(to tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            CardListViewCell.self,
            forCellReuseIdentifier: CardListViewCell.reuseIdentifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
    }

    func setItems(_ items: [CardCellViewModel]) {
        self.items = items
    }
}

extension CardListTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CardListViewCell.reuseIdentifier,
                for: indexPath
            ) as? CardListViewCell
        else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        }

        cell.configure(with: items[indexPath.row])
        return cell
    }
}

extension CardListTableManager: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.cardListTableManagerDidSelect(id: items[indexPath.row].id)
    }
}
