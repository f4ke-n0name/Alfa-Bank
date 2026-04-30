enum BDUITextStyleToken: String, Decodable {
    case title1
    case title2
    case body
    case button
    case caption
    case text12
}

extension BDUITextStyleToken {
    func toTextStyle() -> TextStyle {
        switch self {
        case .title1:
            return .title1
        case .title2:
            return .title2
        case .body:
            return .body
        case .button:
            return .button
        case .caption:
            return .caption
        case .text12:
            return .text12
        }
    }
}
