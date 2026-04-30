import UIKit

struct BDUIMappedScreen {
    let rootView: UIView
    let context: BDUIRenderContext
}

protocol BDUIInteractorInput {
    func loadNode(screen: BDUIScreenType) async throws -> BDUINode
}

protocol BDUIModuleInput {
    func loadScreen(
        _ screen: BDUIScreenType,
        actionHandler: BDUIActionHandling
    )
}

protocol BDUIModuleViewInput: AnyObject {
    func present(screen: BDUIMappedScreen)
    func present(error: String)
}
