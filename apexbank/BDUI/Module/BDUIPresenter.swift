import Foundation

class BDUIPresenter: BDUIModuleInput {
    weak var view: BDUIModuleViewInput?
    private let interactor: BDUIInteractorInput
    private let mapper: BDUIViewMapping

    init(
        interactor: BDUIInteractorInput,
        mapper: BDUIViewMapping
    ) {
        self.interactor = interactor
        self.mapper = mapper
    }

    func loadScreen(
        _ screen: BDUIScreenType,
        actionHandler: BDUIActionHandling
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let rootNode = try await self.interactor.loadNode(screen: screen)
                let mappedScreen = await MainActor.run {
                    let context = BDUIRenderContext(handler: actionHandler)
                    let rootView = self.mapper.map(node: rootNode, context: context)
                    return BDUIMappedScreen(rootView: rootView, context: context)
                }

                await MainActor.run { [weak self] in
                    self?.view?.present(screen: mappedScreen)
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.view?.present(error: error.localizedDescription)
                }
            }
        }
    }
}
