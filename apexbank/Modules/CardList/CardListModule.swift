import UIKit


enum CardListModule {
    static func build(session: NetworkSession = URLSession(configuration: .default)) -> UIViewController {
        let repository = CardListRepository(session: session)
        let view = CardListViewController()
        let presenter = CardListPresenter()
        let interactor = CardListInteractor(repository: repository)
        let router = CardListRouter()

        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view

        return view
    }
}
