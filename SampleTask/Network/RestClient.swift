//
//  RestClient.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 27/08/23.
//

import Foundation
import Network

class RestClient {
    static let sharedInstance: RestClient = RestClient.init()
        
    func sendRequest<T: Codable>(request: BaseApiRequest,
                                 type: T.Type) async throws -> T {
        guard NetworkMonitor.shared.isReachable else {
            throw RequestError.noInternet
        }
        guard let request = request.requestUrl() else {
            throw RequestError.invalidURL
        }
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw RequestError.unknown
        }
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.noResponse
        }
        
        switch response.statusCode {
        case 200...299:
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                debugPrint(error)
                throw RequestError.decode
            }
        case 401:
            throw RequestError.unauthorized
        case 400 ..< 500: //TODO:  will change once api developer change the code.
            guard let payload = try? JSONDecoder().decode(APIError.self, from: data) else {
                throw RequestError.unexpectedStatusCode
            }
            throw RequestError.customError(payload.error)
        default:
            throw RequestError.unexpectedStatusCode
        }
    }
}


struct APIError: Decodable {
    let error: String
    let field: String
    let message: String
}

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case noInternet
    case unknown
    case customError(String)
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .noInternet:
            return "No Internet connection.\nPlease check your Internet connection and try again."
        case .customError(let error):
            return error
        case .unknown:
            return "unknown" // request cancel
        default:
            return "Unknown error"
        }
    }
}



class NetworkMonitor {
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

