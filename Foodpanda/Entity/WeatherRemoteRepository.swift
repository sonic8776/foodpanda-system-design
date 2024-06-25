//
//  WeatherRemoteRepository.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/25.
//

import Foundation

struct WeatherDTO: Codable {
    
    let temperature: Float
    let humidity: Float
    
    enum CodingKeys: String, CodingKey {
        case temperature = "fp_temperature"
        case humidity = "fp_humidity"
    }
}

enum WeatherRemoteRepositoryError: Error {
    case failedToParseData
    case networkError
}

protocol WeatherRemoteRepositoryProtocol {
    func requestWeather(fromCountry country: String, onDate date: String, completion: @escaping (Result<WeatherDTO, WeatherRemoteRepositoryError>) -> Void)
}

class WeatherRemoteRepository: WeatherRemoteRepositoryProtocol {
    let client: HTTPClient
    init(client: HTTPClient) {
        self.client = client
    }
    
    func requestWeather(fromCountry country: String, onDate date: String, completion: @escaping (Result<WeatherDTO, WeatherRemoteRepositoryError>) -> Void) {
        let weatherRequest = WeatherRequest(country: country, date: date)
        client.request(withRequestType: weatherRequest) { result in
            switch result {
            case let .success((data, _)):
                // parsing data to DTO
                do {
                    let dto = try JSONDecoder().decode(WeatherDTO.self, from: data)
                    completion(.success(dto))
                } catch {
                    completion(.failure(.failedToParseData))
                }
            case let .failure(_):
                completion(.failure(.networkError))
            }
        }
    }
}
