import Foundation

struct Book: Codable, Equatable, Identifiable {
    let id: UUID
    var title: String
    var author: String
    var publicationYear: Int?
    var genre: [Genre]
    var tags: [String]
}
