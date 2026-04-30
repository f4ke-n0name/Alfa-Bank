import Foundation

final class BDUIActionDispatcher: BDUIActionHandling {
    private var eventHandlers: [String: ([String: String]?) -> Void] = [:]
    private var routeHandlers: [String: ([String: String]?) -> Void] = [:]
    private var reloadHandler: (([String: String]?) -> Void)?
    private var fallbackHandler: ((BDUIAction) -> Void)?

    func onEvent(named name: String, handler: @escaping ([String: String]?) -> Void) {
        eventHandlers[name] = handler
    }

    func onRoute(target: String, handler: @escaping ([String: String]?) -> Void) {
        routeHandlers[target] = handler
    }

    func onReload(handler: @escaping ([String: String]?) -> Void) {
        reloadHandler = handler
    }

    func onUnhandledAction(handler: @escaping (BDUIAction) -> Void) {
        fallbackHandler = handler
    }

    func handle(action: BDUIAction) {
        switch action.type {
        case .event:
            dispatch(key: action.name, in: eventHandlers, action: action) // внутри bdui screen должен быть
            

        case .route:
            dispatch(key: action.target, in: routeHandlers, action: action)

        case .reload:
            execute(handler: reloadHandler, action: action)
        }
    }

    private func dispatch(
        key: String?,
        in handlers: [String: ([String: String]?) -> Void],
        action: BDUIAction
    ) {
        guard let key, let handler = handlers[key] else {
            fallbackHandler?(action)
            return
        }
        execute(handler: handler, action: action)
    }

    private func execute(handler: (([String: String]?) -> Void)?, action: BDUIAction) {
        guard let handler else {
            fallbackHandler?(action)
            return
        }
        handler(action.context)
    }
}
