//
//  HTTPClient.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/25.
//

import Foundation

protocol HTTPClient {
    func request(withRequestType requestType: RequestType, completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void)
}

enum HTTPClientError: Error {
    case networkError
}
