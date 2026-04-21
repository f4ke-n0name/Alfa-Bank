protocol CardListRouterInput: AnyObject {
    func openCardDetail(from items: [CardCellViewModel], id: String)
    func logout()
}
