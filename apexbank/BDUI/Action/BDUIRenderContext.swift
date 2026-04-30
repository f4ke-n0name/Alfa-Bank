import Foundation
import UIKit

class BDUIRenderContext {
    private var viewsById: [String: UIView] = [:]
    private var handler: BDUIActionHandling

    init(handler: BDUIActionHandling) {
        self.handler = handler
    }

    public func register(id: String?, view: UIView) {
        guard let id else { return }
        viewsById[id] = view
    }

    public func view<UIViewType: UIView>(id: String) -> UIViewType? {
        return viewsById[id] as? UIViewType
    }

    public func handle(action: BDUIAction) {
        handler.handle(action: action)
    }
}
