import Foundation

protocol CardListViewInput {
    func render()
}

protocol CardListViewOutput {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectCard(cardId: String)
    func didPullToRefresh()
}

protocol CardListInteractorInput {
    func getCards(token: String) throws -> [Card]
}

protocol CardListRouterInput {
    func openCardDetail(cardId: UUID, session: UserSession)
}

struct CardListItemViewModel: Equatable, Identifiable {
    let id: UUID
    let number: String
    let holderName: String
    let balance: Double
    let cardType: CardType
    let isActive: Bool
}
