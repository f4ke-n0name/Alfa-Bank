import UIKit

protocol BDUIViewMapping {
    func map(node: BDUINode, context: BDUIRenderContext) -> UIView
}