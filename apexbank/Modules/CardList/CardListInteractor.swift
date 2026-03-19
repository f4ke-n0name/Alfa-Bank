import Foundation

class CardListInteractor: CardListInteractorInput {
    private let repository: CardListRepositoryProtocol

    init(repository: CardListRepositoryProtocol) {
        self.repository = repository
    }

    func loadCards() async throws -> [CardCellViewModel] {
        let dtos = try await repository.getCards()
        guard !dtos.isEmpty else {
            return []
        }
        let cards = dtos.map { mapToDomain($0) }
        return cards.map { mapToViewModel($0) }
    }
    
    private func mapToDomain(_ dto: CardDTO) -> Card {
            return Card(
                id: dto.id,
                number: dto.cardNumber,
                balance: dto.balance,
                holderName: dto.cardholderName,
                type: CardType(rawValue: dto.cardType) ?? .mir,
                expirationDate: dto.expiryDate,
                isActive: dto.isActive,
            )
        }

    private func mapToViewModel(_ card: Card) -> CardCellViewModel {
            let formatter = NumberFormatter()
            let lastFour = String(card.number.suffix(4))
            let balanceText = formatter.string(from: NSNumber(value: card.balance)) ?? "0.00"
        
            return CardCellViewModel(
                id: card.id,
                lastFourDigits: lastFour,
                cardholderName: card.holderName,
                balance: balanceText,
                expiryDate: card.expirationDate,
                cardType: card.type.rawValue,
                isActive: card.isActive
            )
        }
}
