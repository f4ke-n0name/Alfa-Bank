struct BDUINode: Decodable {
    let id: String?
    let type: BDUINodeType
    let payload: BDUIPayload
    let children: [BDUINode]?

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case children
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decode(BDUINodeType.self, forKey: .type)
        children = try container.decodeIfPresent([BDUINode].self, forKey: .children)
        payload = try BDUIPayload(from: decoder)
    }
}
