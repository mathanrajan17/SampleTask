//
//  BaseApiRequest.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 27/08/23.
//

import Foundation

protocol BaseApiRequest {
    var requestBaseUrl: String {get}
    var requestMethod: RequestMethod? { get }
    func requestUrl() -> URLRequest?
}

extension BaseApiRequest {
    public func requestUrl() -> URLRequest? {
        let url: URL! = URL(string: requestBaseUrl)
        var request = URLRequest(url: url)
        switch requestMethod {
        case .get:
            request.httpMethod = RequestMethod.get.rawValue
        case .post:
            request.httpMethod = RequestMethod.post.rawValue
        case .put:
            request.httpMethod = RequestMethod.put.rawValue
        case .delete:
            request.httpMethod = RequestMethod.delete.rawValue
        default:
            request.httpMethod = "GET"
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

