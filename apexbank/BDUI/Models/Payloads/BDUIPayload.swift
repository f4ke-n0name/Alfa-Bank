enum BDUIPayload {
    case label(BDUILabelPayload)
    case button(BDUIButtonPayload)
    case textField(BDUITextFieldPayload)
    case stackView(BDUIStackViewPayload)
    case spacer(BDUISpacerPayload)
}

extension BDUIPayload: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
        case payload
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BDUINodeType.self, forKey: .type)

        switch type {
        case .label:
            self = .label(try container.decode(BDUILabelPayload.self, forKey: .payload))
        case .button:
            self = .button(try container.decode(BDUIButtonPayload.self, forKey: .payload))
        case .textField:
            self = .textField(try container.decode(BDUITextFieldPayload.self, forKey: .payload))
        case .stackView:
            self = .stackView(try container.decode(BDUIStackViewPayload.self, forKey: .payload))
        case .spacer:
            self = .spacer(try container.decode(BDUISpacerPayload.self, forKey: .payload))
        }
    }
}
