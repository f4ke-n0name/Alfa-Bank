import CryptoKit
import Foundation

class AuthRepository: AuthRepositoryProtocol {

    private var usersStorage: [String: UserCredentials] = [:]
    private var sessionsStorage: [String: UserSession] = [:]
    private let emailPattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
    
    static let shared = AuthRepository()
    private init() {}

    func register(request: RegisterRequest) throws -> LoginResponse {
        try validate(email: request.email, password: request.notMaskedPassword)

        guard usersStorage[request.email] == nil else {
            throw AuthError.emailAlreadyTaken
        }

        let id = UUID()
        let user = User(
            id: id,
            firstName: request.firstName,
            lastName: request.lastName,
            email: request.email
        )
        usersStorage[request.email] = UserCredentials(
            user: user,
            passwordHash: hash(request.notMaskedPassword)
        )

        return try login(
            request: LoginRequest(
                email: request.email,
                password: request.notMaskedPassword
            )
        )
    }

    func login(request: LoginRequest) throws -> LoginResponse {
        try validate(email: request.email, password: request.password)

        guard
            let credentials = usersStorage[request.email],
            credentials.passwordHash == hash(request.password)
                
        else {
            throw AuthError.invalidCredentials
        }

        let sessionId = UUID().uuidString
        let expiresAt = Date().addingTimeInterval(3600)

        sessionsStorage[sessionId] = UserSession(
            token: sessionId,
            userId: credentials.user.id,
            expiresAt: expiresAt
        )

        return LoginResponse(
            token: sessionId,
            userId: credentials.user.id,
            expiresAt: expiresAt
        )
    }

    func loadSession(session: UserSession) throws {
        guard session.expiresAt > Date() else {
            throw AuthError.sessionExpired
        }
        sessionsStorage[session.token] = session
    }

    func clearSession() throws {
        sessionsStorage.removeAll()
    }

    private func hash(_ value: String) -> String {
        let data = Data(value.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func validate(email: String, password: String) throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.emptyCredentials
        }
        guard
            email.range(
                of: emailPattern,
                options: [.regularExpression, .caseInsensitive]
            ) != nil
        else {
            throw AuthError.invalidEmailFormat
        }
        guard password.count >= 6 else {
            throw AuthError.passwordTooShort
        }
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case emptyCredentials
    case invalidEmailFormat
    case passwordTooShort
    case emailAlreadyTaken
    case sessionExpired
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Неверный email или пароль"
        case .emptyCredentials: return "Введите email и пароль"
        case .invalidEmailFormat: return "Некорректный формат email"
        case .passwordTooShort:
            return "Пароль должен содержать не менее 6 символов"

        case .emailAlreadyTaken: return "Этот email уже зарегистрирован"

        case .sessionExpired: return "Сессия истекла, пожалуйста, войдите снова"
        }
    }
}
