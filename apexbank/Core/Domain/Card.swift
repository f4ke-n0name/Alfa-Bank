import Foundation

struct Card: Equatable, Identifiable {
    let id: String
    let number: String
    let balance: Double
    let holderName: String
    let type: CardType
    let expirationDate: String
    let isActive : Bool
}
