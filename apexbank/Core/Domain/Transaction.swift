import Foundation

struct Transaction: Equatable, Identifiable {
    let id: UUID
    let cardId: UUID
    let amount: Double
    let date: Date
    let status: TransactionStatus
    let type: TransactionType
}
