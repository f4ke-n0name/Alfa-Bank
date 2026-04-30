import UIKit

enum RegisterModule {
    static func build(repository: AuthRepositoryProtocol?) -> UIViewController {
        let repo = repository ?? AuthRepository.shared
        let jsonLoader = BDUIJSONLoader(session: URLSession.shared)
        let bduiInteractor = BDUIInteractor(loader: jsonLoader)
        let bduiPresenter = BDUIPresenter(
            interactor: bduiInteractor,
            mapper: BDUIViewMapper()
        )
        let view       = RegisterViewController(bduiModule: bduiPresenter)
        let presenter  = RegisterPresenter()
        let interactor = RegisterInteractor(repository: repo)
        let router     = RegisterRouter()

        view.output           = presenter
        presenter.view        = view
        presenter.interactor  = interactor
        presenter.router      = router
        router.viewController = view
        bduiPresenter.view = view

        return view
    }
}
