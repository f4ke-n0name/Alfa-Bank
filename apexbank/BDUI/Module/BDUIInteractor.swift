class BDUIInteractor: BDUIInteractorInput {
    private let loader: BDUIJSONLoading

    init(loader: BDUIJSONLoading) {
        self.loader = loader
    }

    func loadNode(screen: BDUIScreenType) async throws -> BDUINode {
        try await loader.loadScreen(named: screen.endpoint)
    }
}
