import Foundation

struct User: Equatable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
}
