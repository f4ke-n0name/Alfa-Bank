enum BDUIScreenType {
    case auth
    case register
    case custom(String)

    var endpoint: String {
        switch self {
        case .auth:
            return "auth"
        case .register:
            return "register"
        case .custom(let endpoint):
            return endpoint
        }
    }
}
