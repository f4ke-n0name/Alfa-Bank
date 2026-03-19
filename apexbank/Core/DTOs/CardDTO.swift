import Foundation

struct CardResponse: Decodable {
    let cards: [CardDTO]
}

struct CardDTO: Decodable {
    let id: String
    let cardNumber: String
    let cardholderName: String
    let balance : Double
    let expiryDate: String
    let cardType: String
    let isActive: Bool
}
