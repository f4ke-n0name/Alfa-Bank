protocol CardListInteractorInput: AnyObject {
    func loadCards() async throws -> [Card]
}
