import Foundation

struct CardCellViewModel: Equatable {
    let id: String
    let number: String
    let lastFourDigits: String
    let cardholderName: String
    let balance: String
    let expiryDate: String
    let cardType: String
    let isActive: Bool
}

enum CardListState {
    case idle
    case loading
    case content([CardCellViewModel])
    case empty
    case error(String)
}
