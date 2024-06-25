//
//  WeatherUseCase.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/25.
//

import Foundation

struct Weather {
    
    let temperature: Float // to formatted string
    let humidity: Float
    
    init(fromDTO dto: WeatherDTO) {
        self.temperature = dto.temperature
        self.humidity = dto.humidity
    }
}

enum WeatherUseCaseError: Error {
    case userCaseError
}

protocol WeatherUseCaseProtocol {
    func loadWeather(fromCountry country: String, OnDate date: String, completion: @escaping ((Result<Weather, WeatherUseCaseError>) -> Void))
}

class WeatherUseCase: WeatherUseCaseProtocol {
    
    let remoteRepo: WeatherRemoteRepositoryProtocol
    
    init(remoteRepo: WeatherRemoteRepositoryProtocol) {
        self.remoteRepo = remoteRepo
    }
    
    func loadWeather(fromCountry country: String, OnDate date: String, completion: @escaping ((Result<Weather, WeatherUseCaseError>) -> Void)) {
        remoteRepo.requestWeather(fromCountry: country, onDate: date) { result in
            switch result {
            case let .success(weatherDTO):
                let weather = Weather(fromDTO: weatherDTO)
                completion(.success(weather))
                
            case .failure(_):
                completion(.failure(.userCaseError))
            }
        }
    }
}
