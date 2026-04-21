import UIKit

final class CardListRouter: CardListRouterInput {
    weak var viewController: UIViewController?

    func openCardDetail(from items: [CardCellViewModel], id: String) {
        guard let selected = items.first(where: { $0.id == id }) else { return }
        let vc = CardDetailModule.build(viewModel: selected)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func logout() {
        viewController?.navigationController?.setViewControllers([AuthModule.build()], animated: true)
    }
}
