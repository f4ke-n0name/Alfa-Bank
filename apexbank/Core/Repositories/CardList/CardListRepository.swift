import Foundation

class CardListRepository: CardListRepositoryProtocol {

    private let url = URL(string: "https://alfaitmo.ru/server/echo/408099/cards/list")!

    func getCards() async throws -> [CardDTO] {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.badResponse(statusCode: -1)
            }
            guard 200..<300 ~= http.statusCode else {
                throw NetworkError.badResponse(statusCode: http.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let cardResponse = try decoder.decode(CardResponse.self, from: data)
            return cardResponse.cards

        } catch let error as NetworkError {
            throw error
        } catch is DecodingError {
            throw NetworkError.decodingFailed
        } catch let urlError as URLError {
            if urlError.code == .notConnectedToInternet {
                throw NetworkError.noConnection
            }
            throw NetworkError.unknown(urlError)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
