//
//  WeatherRequest.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/25.
//

import Foundation

// https://foodpanda.com/weather?country=taiwan&date=20240625

struct WeatherRequest: RequestType {
    var domainURL: URL { .init(string: "https://foodpanda.com")! }
    
    var path: String { "weather" }
    
    var queryItems: [URLQueryItem] {
        [
            .init(name: "country", value: country),
            .init(name: "date", value: date),
        ]
    }
    
    var httpMethod: HTTPMethod { .get }
    
    var body: Data? { nil }
    
    var headers: [String : Any]? { nil }
    
    var country: String
    var date: String
    
    init(country: String, date: String) {
        self.country = country
        self.date = date
    }
    
}
