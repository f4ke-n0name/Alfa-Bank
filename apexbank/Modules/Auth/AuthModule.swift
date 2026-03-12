import UIKit

enum AuthModule {
    static func build() -> UIViewController {
        let repository = AuthRepository.shared
        let view       = AuthViewController()
        let presenter  = AuthPresenter()
        let interactor = AuthInteractor(repository: repository)
        let router     = AuthRouter()

        router.repository = repository
        
        view.output           = presenter
        presenter.view        = view
        presenter.interactor  = interactor
        presenter.router      = router
        router.viewController = view

        return view
    }
}
