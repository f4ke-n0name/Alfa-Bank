import Foundation

class CLI {
    private var bookShelf: BookShelfProtocol
    
    init(bookShelf: BookShelfProtocol) {
         self.bookShelf = bookShelf
    }
    
    func run() {
        print("=== BookShelf CLI ===")
        print("Доступные команды: add, list, search, delete, help, exit")
        
        while true {
            print("\nВведите команду:")
            if let command = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                switch command {
                case "add":
                    showAddBook()
                case "list":
                    showListBooks()
                case "search":
                    showSearch()
                case "delete":
                    showDelete()
                case "help":
                    print("\nДоступные команды: add, list, search, delete, help, exit")
                case "exit":
                    print("Выход из программы")
                    return
                default:
                    print("Неизвестная команда")
                }
            }
        }
    }
    
    private func showAddBook() {
        print("\n--- Добавление книги ---")
        
        print("Название:")
        guard let title = readLine() else {
            print("Ошибка ввода")
            return
        }
        
        print("Автор:")
        guard let author = readLine() else {
            print("Ошибка ввода")
            return
        }
        
        print("Год издания:")
        guard let yearString = readLine(), let year = Int(yearString) else {
            print("Некорректный год")
            return
        }
        
        print("Жанры (fiction, nonFiction, mystery, sciFi, biography, fantasy) через запятую:")
        guard let genreString = readLine() else {
            print("Ошибка ввода")
            return
        }
        
        let genres = genreString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .compactMap { Genre(rawValue: String($0).trimmingCharacters(in: .whitespacesAndNewlines)) }
        
        print("Теги через запятую:")
        guard let tagString = readLine() else {
            print("Ошибка ввода")
            return
        }
        
        let tags = tagString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        
        let book = Book(
            id: UUID(),
            title: title,
            author: author,
            publicationYear: year,
            genre: genres,
            tags: tags
        )
        
        do {
            try bookShelf.add(book)
            print("Книга добавлена: \(book.title)")
        } catch {
            print("Ошибка: \(error)")
        }
    }
    
    private func showListBooks() {
        print("\n--- Список книг ---")
        
        let books = bookShelf.list()
        
        if books.isEmpty {
            print("Книг нет")
            return
        }
        
        print("Всего книг: \(books.count)")
        
        for book in books {
            print("- \(book.title) (\(book.author), \(book.publicationYear ?? 0))")
            print("  Жанры: \(book.genre.map { $0.rawValue }.joined(separator: ", "))")
            print("  Теги: \(book.tags.joined(separator: ", "))")
        }
    }
    
    private func showSearch() {
        print("\n--- Поиск ---")
        print("Тип поиска (title, author, genre, tag, year):")
        
        guard let type = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
            print("Ошибка ввода")
            return
        }
        
        print("Поисковый запрос:")
        guard let query = readLine() else {
            print("Ошибка ввода")
            return
        }
        
        do {
            var results: [Book] = []
            
            switch type {
            case "title":
                results = try bookShelf.search(.title(query))
            case "author":
                results = try bookShelf.search(.author(query))
            case "genre":
                if let genre = Genre(rawValue: query.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    results = try bookShelf.search(.genre(genre))
                } else {
                    print("Неверный жанр")
                    return
                }
            case "tag":
                results = try bookShelf.search(.tag(query))
            case "year":
                if let year = Int(query) {
                    results = try bookShelf.search(.year(year))
                } else {
                    print("Неверный год")
                    return
                }
            default:
                print("Неверный тип поиска")
                return
            }
            
            if results.isEmpty {
                print("Ничего не найдено")
            } else {
                print("Найдено книг: \(results.count)")
                for book in results {
                    print("- \(book.title) (\(book.author), \(book.publicationYear ?? 0))")
                }
            }
        } catch {
            print("Ошибка поиска: \(error)")
        }
    }
    
    private func showDelete() {
        print("\n--- Удаление книги ---")
        
        let books = bookShelf.list()
        
        if books.isEmpty {
            print("Книг нет")
            return
        }
        
        print("Доступные книги:")
        for (index, book) in books.enumerated() {
            print("\(index + 1). \(book.title) (id: \(book.id.uuidString.prefix(8))...)")
        }
        
        print("Введите номер книги для удаления:")
        guard let input = readLine(), let index = Int(input), index > 0, index <= books.count else {
            print("Неверный номер")
            return
        }
        
        let bookToDelete = books[index - 1]
        
        do {
            try bookShelf.delete(id: bookToDelete.id)
            print("Книга удалена: \(bookToDelete.title)")
        } catch {
            print("Ошибка: \(error)")
        }
    }
}
