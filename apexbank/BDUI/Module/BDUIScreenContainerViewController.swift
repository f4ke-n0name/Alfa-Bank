import UIKit

class BDUIScreenContainerViewController: UIViewController, BDUIModuleViewInput {
    var onAction: ((BDUIAction) -> Void)?
    var onScreenLoaded: (() -> Void)?

    private let bduiModule: BDUIModuleInput
    private let screen: BDUIScreenType
    private let actionDispatcher = BDUIActionDispatcher()
    private var bduiRootView: UIView?
    private var renderContext: BDUIRenderContext?

    init(
        screen: BDUIScreenType,
        bduiModule: BDUIModuleInput
    ) {
        self.screen = screen
        self.bduiModule = bduiModule
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseActionHandlers()
        loadBDUIScreen()
    }

    func present(screen: BDUIMappedScreen) {
        renderContext = screen.context
        install(rootView: screen.rootView)
        onScreenLoaded?()
    }

    func present(error: String) {
        showBDUIError(error)
    }

    func onEvent(named name: String, handler: @escaping ([String: String]?) -> Void) {
        actionDispatcher.onEvent(named: name, handler: handler)
    }

    func onRoute(target: String, handler: @escaping ([String: String]?) -> Void) {
        actionDispatcher.onRoute(target: target, handler: handler)
    }

    func viewById<ViewType: UIView>(_ id: String) -> ViewType? {
        renderContext?.view(id: id)
    }

    func withView<ViewType: UIView>(
        id: String,
        as _: ViewType.Type = ViewType.self,
        _ update: (ViewType) -> Void
    ) {
        guard let view: ViewType = viewById(id) else { return }
        update(view)
    }

    private func configureBaseActionHandlers() {
        actionDispatcher.onReload { [weak self] _ in
            self?.loadBDUIScreen()
        }
        actionDispatcher.onUnhandledAction { [weak self] action in
            self?.onAction?(action)
        }
    }

    private func loadBDUIScreen() {
        bduiModule.loadScreen(screen, actionHandler: actionDispatcher)
    }

    private func install(rootView: UIView) {
        rootView.translatesAutoresizingMaskIntoConstraints = false
        bduiRootView?.removeFromSuperview()
        bduiRootView = rootView
        view.addSubview(rootView)

        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func showBDUIError(_ message: String) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.apply(.body)
        label.text = "Не удалось загрузить экран.\n\(message)"
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l)
        ])
    }
}
