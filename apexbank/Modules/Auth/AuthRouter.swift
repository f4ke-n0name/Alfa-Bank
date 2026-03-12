import UIKit

class AuthRouter: AuthRouterInput {

    weak var viewController: UIViewController?
    var repository: AuthRepositoryProtocol?

    func openCardList(session: UserSession) {
        let cardListVC = CardListStubViewController(session: session)
        let nav = viewController?.navigationController
        if let nav = nav {
            nav.setViewControllers([cardListVC], animated: true)
        } else {
            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first
            else { return }
            let navController = UINavigationController(rootViewController: cardListVC)
            UIView.transition(with: window,
                              duration: 0.52,
                              options: .transitionCrossDissolve,
                              animations: { window.rootViewController = navController })
        }
    }

    func openRegistration() {
        guard let repository else { return }
        let vc = RegisterModule.build(repository: repository)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
