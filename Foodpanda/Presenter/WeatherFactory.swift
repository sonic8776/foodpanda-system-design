//
//  WeatherFactory.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/29.
//

import Foundation

class WeatherFactory {
    
    static func makeViewModel() -> WeatherViewModel {
        let client = URLSessionHTTPClient(session: .shared)
        let remoteRepo = WeatherRemoteRepository(client: client)
        let useCase = WeatherUseCase(remoteRepo: remoteRepo)
        return WeatherViewModel(useCase: useCase)
    }
    
}
