//
//  WeatherUseCaseTests.swift
//  FoodpandaTests
//
//  Created by Judy Tsai on 2024/6/29.
//

import XCTest
@testable import Foodpanda

class WeatherUseCaseTests: XCTestCase {
    
    func test_loadWeather_withSuccessfullyGetWeatherDTO() {
        let (sut, spy) = makeSUT()
        let expectedWeatherDTO = WeatherDTO.init(temperature: 23.3, humidity: 11.5)
        let expectation = expectation(description: "Wait for completion...")
        
        // 8: execute completionForTesting, and compare the success result
        let completionForTesting: ((Result<Weather, WeatherUseCaseError>) -> Void) = { result in
            expectation.fulfill()
            switch result {
            case let .success(weather):
                // 9: compare temperature and humidity
                XCTAssertEqual(weather.temperature, expectedWeatherDTO.temperature)
                XCTAssertEqual(weather.humidity, expectedWeatherDTO.humidity)
            default:
                XCTFail("Should not be failed!")
            }
        }
        // 1: call useCase loadWeather and set completionForTesting to loadWeather
        sut.loadWeather(fromCountry: "", OnDate: "", completionForViewModel: completionForTesting)
        
        // 4: ask RemoteRepositorySpy to execute completion with .success(DTO) result
        spy.complete(withWeatherDTO: expectedWeatherDTO)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loadWeather_withFailedGetParsingError() {
        let (sut, spy) = makeSUT()
        let expectedError = WeatherUseCaseError.parsingError
        let expectation = expectation(description: "Wait for completion...")
        
        let completionForTesting: ((Result<Weather, WeatherUseCaseError>) -> Void) = { result in
            expectation.fulfill()
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(expectedError, receivedError)
            default:
                XCTFail("Should not be successful!")
            }
        }
        sut.loadWeather(fromCountry: "", OnDate: "", completionForViewModel: completionForTesting)
        
        let spyError = WeatherRemoteRepositoryError.failedToParseData
        spy.complete(withError: spyError)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loadWeather_withFailedGetUseCaseError() {
        let (sut, spy) = makeSUT()
        let expectedError = WeatherUseCaseError.useCaseError
        let expectation = expectation(description: "Wait for completion...")
        
        let completionForTesting: ((Result<Weather, WeatherUseCaseError>) -> Void) = { result in
            expectation.fulfill()
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(expectedError, receivedError)
            default:
                XCTFail("Should not be successful!")
            }
        }
        sut.loadWeather(fromCountry: "", OnDate: "", completionForViewModel: completionForTesting)
        
        let spyError = WeatherRemoteRepositoryError.networkError
        spy.complete(withError: spyError)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loadWeather_withCorrectOrders() {
        let (sut, spy) = makeSUT()
        let expectation1 = expectation(description: "Wait for first failure completion...")
        let expectation2 = expectation(description: "Wait for second successful completion...")
        let expectation3 = expectation(description: "Wait for third failure completion...")
        let expectedError1 = WeatherUseCaseError.parsingError
        let expectedWeatherDTO = WeatherDTO.init(temperature: 23.3, humidity: 11.5)
        let expectedError2 = WeatherUseCaseError.useCaseError
        
        sut.loadWeather(fromCountry: "", OnDate: "") { result in
            expectation1.fulfill()
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(expectedError1, receivedError)
            default:
                XCTFail("Should not be successful!")
            }
        }
        
        sut.loadWeather(fromCountry: "", OnDate: "") { result in
            expectation2.fulfill()
            switch result {
            case let .success(weather):
                // 9: compare temperature and humidity
                XCTAssertEqual(weather.temperature, expectedWeatherDTO.temperature)
                XCTAssertEqual(weather.humidity, expectedWeatherDTO.humidity)
            default:
                XCTFail("Should not be failed!")
            }
        }
        
        sut.loadWeather(fromCountry: "", OnDate: "") { result in
            expectation3.fulfill()
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(expectedError2, receivedError)
            default:
                XCTFail("Should not be successful!")
            }
        }
        
        spy.complete(withError: .failedToParseData, atIndex: 0)
        spy.complete(withWeatherDTO: expectedWeatherDTO, atIndex: 1)
        spy.complete(withError: .networkError, atIndex: 2)
        
        wait(for: [expectation1, expectation2, expectation3], timeout: 1.0)
    }
}

private extension WeatherUseCaseTests {
    // Mock Data
    class RemoteRepositorySpy: WeatherRemoteRepositoryProtocol {
        
        var completions = [(Result<Foodpanda.WeatherDTO, Foodpanda.WeatherRemoteRepositoryError>) -> Void]()
        
        // 3: call request weather and append completion to completions array
        func requestWeather(fromCountry country: String, onDate date: String, completion: @escaping (Result<Foodpanda.WeatherDTO, Foodpanda.WeatherRemoteRepositoryError>) -> Void) {
            completions.append(completion)
        }
        
        func complete(withError error: WeatherRemoteRepositoryError, atIndex index: Int = 0) {
            completions[index](.failure(error))
        }
        
        // 5: setup .success(weatherDTO) to completion and execute completion
        func complete(withWeatherDTO weatherDTO: Foodpanda.WeatherDTO, atIndex index: Int = 0) {
            completions[index](.success(weatherDTO)) // -> completion(.success(DTO))
        }
    }
    
    func makeSUT() -> (WeatherUseCase, RemoteRepositorySpy) {
        let spy = RemoteRepositorySpy()
        let sut = WeatherUseCase(remoteRepo: spy)
        return (sut, spy)
    }
}
