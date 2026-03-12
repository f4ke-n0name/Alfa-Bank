import UIKit

enum RegisterModule {
    static func build(repository: AuthRepositoryProtocol) -> UIViewController {
        let view       = RegisterViewController()
        let presenter  = RegisterPresenter()
        let interactor = RegisterInteractor(repository: repository)
        let router     = RegisterRouter()

        view.output           = presenter
        presenter.view        = view
        presenter.interactor  = interactor
        presenter.router      = router
        router.viewController = view

        return view
    }
}
