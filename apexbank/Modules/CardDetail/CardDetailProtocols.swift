import Foundation

protocol CardDetailViewInput {
    func render()
}

protocol CardDetailViewOutput {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
    func didTapShowTransactions()
    func didTapBlockCard()
}

protocol CardDetailInteractorInput {
    func getCardDetails(cardId: UUID, token: String) throws -> Card
    func blockCard(cardId: UUID, token: String) throws
}

protocol CardDetailRouterInput {
    func openTransactions(cardId: UUID, session: UserSession)
    func dismiss()
}

struct CardDetailViewModel: Equatable {
    let id: UUID
    let number: String
    let holderName: String
    let expiryDate: String
    let balance: Double
    let cardType: CardType
}
