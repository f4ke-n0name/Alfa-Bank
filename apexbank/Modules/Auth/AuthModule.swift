import UIKit

enum AuthModule {
    static func build() -> UIViewController {
        let repository = AuthRepository.shared
        let jsonLoader = BDUIJSONLoader(session: URLSession.shared)
        let bduiInteractor = BDUIInteractor(loader: jsonLoader)
        let bduiPresenter = BDUIPresenter(
            interactor: bduiInteractor,
            mapper: BDUIViewMapper()
        )
        let view       = AuthViewController(bduiModule: bduiPresenter)
        let presenter  = AuthPresenter()
        let interactor = AuthInteractor(repository: repository)
        let router     = AuthRouter()

        router.repository = repository
        
        view.output           = presenter
        presenter.view        = view
        presenter.interactor  = interactor
        presenter.router      = router
        router.viewController = view
        bduiPresenter.view = view

        return view
    }
}
