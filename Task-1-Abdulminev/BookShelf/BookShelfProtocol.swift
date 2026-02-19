import Foundation

protocol BookShelfProtocol {
    func add (_ book: Book) throws
    func delete(id: UUID) throws
    func list() -> [Book]
    func search(_ query: SearchQuery) throws -> [Book]
}

