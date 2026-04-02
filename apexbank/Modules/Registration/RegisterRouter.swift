import UIKit

class RegisterRouter: RegisterRouterInput {

    weak var viewController: UIViewController?

    func openCardList(session: UserSession) {
        let cardListVC = CardListModule.build()
        guard let nav = viewController?.navigationController else { return }
        nav.setViewControllers([cardListVC], animated: true)
    }

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
