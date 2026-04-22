import Foundation

class CardListInteractor: CardListInteractorInput {
    private let repository: CardListRepositoryProtocol

    init(repository: CardListRepositoryProtocol) {
        self.repository = repository
    }

    func loadCards() async throws -> [Card] {
        let dtos = try await repository.getCards()
        return dtos.map { mapToDomain($0) }
    }

    private func mapToDomain(_ dto: CardDTO) -> Card {
        return Card(
            id: dto.id,
            number: dto.cardNumber,
            balance: dto.balance,
            holderName: dto.cardholderName,
            type: CardType(rawValue: dto.cardType) ?? .mir,
            expirationDate: dto.expiryDate,
            isActive: dto.isActive
        )
    }
}
