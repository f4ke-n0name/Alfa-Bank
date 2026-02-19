import Foundation

class BookShelf: BookShelfProtocol {

    var books: [Book] = []

    private let minPublicationYear = 1400
    private let maxPublicationYear = 2026

    private func validate(title: String, author: String, year: Int?) throws {
        var trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        var trimmedAuthor = author.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if trimmedTitle.isEmpty {
            throw BookShelfError.emptyTitle
        }
        if trimmedAuthor.isEmpty {
            throw BookShelfError.emptyAuthor
        }
        if let year = year {
            if year < minPublicationYear || year > maxPublicationYear {
                throw BookShelfError.invalidYear(year)
            }
        } else {
            throw BookShelfError.invalidYear(0)
        }
    }

    private func normalize(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    private func normalizeTags(_ tags: [String]) -> [String] {
        return tags.map { normalize($0) }.filter { !$0.isEmpty }
    }

    func add(_ book: Book) throws {
        try validate(
            title: book.title,
            author: book.author,
            year: book.publicationYear
        )
        if books.contains(where: { $0.id == book.id }) {
            throw BookShelfError.duplicateId(book.id.uuidString)
        }

        var normalizedBook = book
        normalizedBook.title = book.title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        normalizedBook.author = book.author.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        normalizedBook.tags = normalizeTags(book.tags)

        books.append(normalizedBook)
    }

    func delete(id: UUID) throws {
        if books.contains(where: { $0.id == id }) == false {
            throw BookShelfError.notFound(id: id.uuidString)
        }
        books.removeAll(where: { $0.id == id })
    }

    func list() -> [Book] {
        return books
    }

    func search(_ query: SearchQuery) throws -> [Book] {
        switch query {
        case .title(let bookTitle):
            let normalized = normalize(bookTitle)
            if normalized.isEmpty {
                throw BookShelfError.emptySearchQuery
            }
            return books.filter { normalize($0.title).contains(normalized) }

        case .author(let bookAuthor):
            let normalized = normalize(bookAuthor)
            if normalized.isEmpty {
                throw BookShelfError.emptySearchQuery
            }
            return books.filter { normalize($0.author).contains(normalized) }

        case .genre(let bookGenre):
            return books.filter { $0.genre.contains(bookGenre) }

        case .tag(let bookTag):
            let normalized = normalize(bookTag)
            if normalized.isEmpty {
                throw BookShelfError.emptySearchQuery
            }
            return books.filter { $0.tags.contains(normalized) }

        case .year(let bookYear):
            if minPublicationYear > bookYear || maxPublicationYear < bookYear {
                throw BookShelfError.invalidYear(bookYear)
            }
            return books.filter { $0.publicationYear == bookYear }
        }
    }

}
