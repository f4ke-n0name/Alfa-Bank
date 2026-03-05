import Foundation

protocol TransactionsViewInput {
    func render()
}

protocol TransactionsViewOutput {
    func viewDidLoad()
    func viewDidAppear()
    func didSwitchTab(_ tab: TransactionsTab)
    func didChangeFilter(_ filter: TransactionFilter)
    func didSelectTransaction(id: UUID)
    func didPullToRefresh()
    func didChangeToCard(id: UUID)
    func didChangeAmount(_ amount: Double)
    func didTapConfirmTransfer()
    func didTapCancelTransfer()
}

protocol TransactionsInteractorInput {
    func getTransactions(
        cardId: UUID,
        token: String,
        filter: TransactionFilter
    ) throws -> [Transaction]
    func runTransaction(
        fromCardId: UUID,
        toCardId: UUID,
        amount: Decimal,
        token: String
    ) throws -> Transaction
}

protocol TransactionsRouterInput {
    func complete()
    func dismiss()
}

enum TransactionsTab: Equatable {
    case history
    case transfer
}

struct TransactionItemViewModel: Equatable, Identifiable {
    let id: UUID
    let merchant: String
    let amount: Double
    let time: String
    let isIncoming: Bool
    let status: TransactionStatus
}

struct CardPickerItem: Equatable, Identifiable {
    let id: UUID
    let number: String
    let holderName: String
    let balanceFormatted: String
}

struct TransferResultViewModel: Equatable {
    let transactionId: UUID
    let toCard: UUID
    let amount: String
    let date: String
}

enum TransactionFilter: Equatable {
    case all
    case incoming
    case outgoing
}
