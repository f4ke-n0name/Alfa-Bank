import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case badResponse(statusCode: Int)
    case decodingFailed
    case noConnection
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный адрес запроса"
        case .badResponse(let code):
            return "Ошибка сервера: \(code)"
        case .decodingFailed:
            return "Не удалось обработать данные"
        case .noConnection:
            return "Нет подключения к интернету"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
