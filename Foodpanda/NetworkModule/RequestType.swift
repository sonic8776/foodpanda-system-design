//
//  RequestType.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/25.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

protocol RequestType {
    var domainURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var httpMethod: HTTPMethod { get }
    var body: Data? { get }
    var headers: [String: Any]? { get }
}

extension RequestType {
    var fullURL: URL {
        var component = URLComponents(url: domainURL, resolvingAgainstBaseURL: false)
        component?.path.append(path)
        component?.queryItems = queryItems
        guard let url = component?.url else {
            fatalError("url is nil!")
        }
        return url
    }
    
    var urlRequest: URLRequest {
        return .init(url: fullURL)
    }
}
