import UIKit

class RegisterRouter: RegisterRouterInput {

    weak var viewController: UIViewController?

    func openCardList(session: UserSession) {
        let cardListVC = CardListStubViewController(session: session)
        guard let nav = viewController?.navigationController else { return }
        nav.setViewControllers([cardListVC], animated: true)
    }

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
