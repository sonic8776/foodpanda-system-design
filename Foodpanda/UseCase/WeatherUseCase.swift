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
    case parsingError
}

protocol WeatherUseCaseProtocol {
    func loadWeather(fromCountry country: String, OnDate date: String, completionForViewModel: @escaping ((Result<Weather, WeatherUseCaseError>) -> Void))
}

class WeatherUseCase: WeatherUseCaseProtocol {
    
    let remoteRepo: WeatherRemoteRepositoryProtocol
    
    init(remoteRepo: WeatherRemoteRepositoryProtocol) {
        self.remoteRepo = remoteRepo
    }
    
    func loadWeather(fromCountry country: String, OnDate date: String, completionForViewModel: @escaping ((Result<Weather, WeatherUseCaseError>) -> Void)) {
        
        // 6: execute completionForUseCase and the result is .success(weatherDTO)
        let completionForUseCase: (Result<WeatherDTO, WeatherRemoteRepositoryError>) -> Void = { result in
            switch result {
            case let .success(weatherDTO):
                let weather = Weather(fromDTO: weatherDTO)
                // 7: execute completionForViewModel
                completionForViewModel(.success(weather))
            case let .failure(repoError):
                switch repoError {
                case .failedToParseData:
                    completionForViewModel(.failure(.parsingError))
                case .networkError:
                    completionForViewModel(.failure(.userCaseError))
                }
                
            }
            
        }

        // 2: ask remoteRepoSpy to call requestWeather, and set completionForUseCase for requestWeather
        remoteRepo.requestWeather(fromCountry: country, onDate: date, completion: completionForUseCase)
    }
}
