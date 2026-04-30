struct BDUIAction: Decodable {
    enum ActionType: String, Decodable {
        case event
        case route // не совсем bdui
        case reload
    }

    let type: ActionType
    let name: String?
    let target: String?
    let context: [String: String]?
}
