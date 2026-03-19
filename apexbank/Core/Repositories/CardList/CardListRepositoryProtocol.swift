protocol CardListRepositoryProtocol {
    func getCards() async throws -> [CardDTO]
}
