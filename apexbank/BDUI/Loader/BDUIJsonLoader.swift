import Foundation

protocol BDUIJSONLoading {
    func loadScreen(named endpoint: String) async throws -> BDUINode
    func loadAuth() async throws -> BDUINode
    func loadRegister() async throws -> BDUINode
}

final class BDUIJSONLoader: BDUIJSONLoading {
    private let baseURL = URL(string: "https://alfaitmo.ru/server/echo/408099/bdui/")!
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func loadAuth() async throws -> BDUINode {
        try await loadScreen(named: Endpoint.auth.rawValue)
    }

    func loadRegister() async throws -> BDUINode {
        try await loadScreen(named: Endpoint.register.rawValue)
    }

    func loadScreen(named endpoint: String) async throws -> BDUINode {
        let url = baseURL.appendingPathComponent(endpoint)
        do {
            let (data, response) = try await session.data(from: url)

            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.badResponse(statusCode: -1)
            }
            guard 200..<300 ~= http.statusCode else {
                throw NetworkError.badResponse(statusCode: http.statusCode)
            }

            let decoder = JSONDecoder()
            return try decoder.decode(BDUINode.self, from: data)
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

    private enum Endpoint: String {
        case auth
        case register
    }
}


