import Foundation

class CardListPresenter {
    weak var view: CardListViewInput?
    var interactor: CardListInteractorInput?
    var router: CardListRouterInput?

    private var state: CardListState = .idle
    private var isLoading = false

    private var lastItems: [CardCellViewModel] = []

    @MainActor
    private func render(_ newState: CardListState) {
        state = newState
        view?.render(newState)
    }

    private func load() {
        guard !isLoading else { return }
        isLoading = true

        Task { @MainActor [weak self] in
            guard let self else { return }
            self.render(.loading)
        }

        Task { [weak self] in
            guard let self else { return }
            defer { self.isLoading = false }
            do {
                let cards = try await self.interactor?.loadCards() ?? []
                let items = cards.map { self.mapToViewModel($0) }
                self.lastItems = items
                await MainActor.run {
                    if items.isEmpty {
                        self.render(.empty)
                    } else {
                        self.render(.content(items))
                    }
                }
            } catch {
                await MainActor.run {
                    self.render(.error(error.localizedDescription))
                }
            }
        }
    }

    private func mapToViewModel(_ card: Card) -> CardCellViewModel {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""

        let lastFour = String(card.number.suffix(4))
        let balanceText = formatter.string(from: NSNumber(value: card.balance)) ?? "0.00"

        return CardCellViewModel(
            id: card.id,
            number: card.number,
            lastFourDigits: lastFour,
            cardholderName: card.holderName,
            balance: balanceText,
            expiryDate: card.expirationDate,
            cardType: card.type.rawValue,
            isActive: card.isActive
        )
    }
}

extension CardListPresenter: CardListViewOutput {
    func viewDidLoad() {
        load()
    }

    func didRequestReload() {
        load()
    }

    func didSelectItem(id: String) {
        router?.openCardDetail(from: lastItems, id: id)
    }

    func didTapLogout() {
        router?.logout()
    }
}
