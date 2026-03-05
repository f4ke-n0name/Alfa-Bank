import Foundation

struct Card: Equatable, Identifiable {
    let id: UUID
    let number: Int
    let balance: Double
    let holderName: String
    let type: CardType
    let expirationDate: Date
}
