import Foundation

struct LoginResponse {
    let token: String
    let userId: UUID
    let expiresAt: Date
}
