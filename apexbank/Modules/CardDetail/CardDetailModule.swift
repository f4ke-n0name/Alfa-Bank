import UIKit

enum CardDetailModule {
    static func build(viewModel: CardCellViewModel) -> UIViewController {
        CardDetailViewController(viewModel: viewModel)
    }
}
