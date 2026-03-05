import Foundation

struct UserSession {
    let token: String
    let userId: UUID
    let expiresAt: Date
}
