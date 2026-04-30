struct BDUIButtonPayload: Decodable {
    let title: String
    let action: BDUIAction?
    let onTap: BDUIAction?
}

extension BDUIButtonPayload {
    func toDSButton() -> DSButton {
        return DSButton(title: title)
    }
}
