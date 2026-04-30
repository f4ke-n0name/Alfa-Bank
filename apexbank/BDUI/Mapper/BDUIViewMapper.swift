import UIKit

class BDUIViewMapper: BDUIViewMapping {
    func map(node: BDUINode, context: BDUIRenderContext) -> UIView {
        let view: UIView

        switch node.payload {
        case .label(let payload):
            view = payload.toLabel()

        case .button(let payload):
            let button = payload.toDSButton()
            if let action = payload.onTap ?? payload.action {
                bind(action: action, to: button, event: .touchUpInside, context: context)
            }
            view = button

        case .textField(let payload):
            let textField = payload.toTextField()
            if let action = payload.onChange {
                bind(action: action, to: textField, event: .editingChanged, context: context)
            }
            if let action = payload.onReturn {
                bind(action: action, to: textField, event: .editingDidEndOnExit, context: context)
            }
            view = textField

        case .spacer(let payload):
            let spacer = payload.toSpacer()
            if let height = payload.height?.toCGFloat() {
                spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
            if let width = payload.width?.toCGFloat() {
                spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
            }
            view = spacer

        case .stackView(let payload):
            let stackView = payload.toStackView()
            for child in node.children ?? [] {
                let childView = map(node: child, context: context)
                stackView.addArrangedSubview(childView)
            }
            view = stackView
        }

        context.register(id: node.id, view: view)
        return view
    }

    private func bind(
        action: BDUIAction,
        to control: UIControl,
        event: UIControl.Event,
        context: BDUIRenderContext
    ) {
        control.addAction(
            UIAction { _ in
                context.handle(action: self.makeAction(action, from: control)) // weak self 
            },
            for: event
        )
    }

    private func makeAction(_ action: BDUIAction, from control: UIControl) -> BDUIAction {
        var actionContext = action.context ?? [:]
        if let textField = control as? UITextField {
            actionContext["text"] = textField.text ?? ""
        }

        return BDUIAction(
            type: action.type,
            name: action.name,
            target: action.target,
            context: actionContext
        )
    }
}
