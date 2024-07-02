//
//  WeatherViewModelTests.swift
//  FoodpandaTests
//
//  Created by Judy Tsai on 2024/7/2.
//

import XCTest
@testable import Foodpanda

class WeatherViewModelTests: XCTestCase {
    
    func test_loadTaiwanWeather_withSuccess() {
        let expectedWeather = Weather(fromDTO: .init(temperature: 11.9, humidity: 13.6))
        expect(withUseCaseResult: .success(expectedWeather)) { weather in
            XCTAssertEqual(weather.temperature, expectedWeather.temperature)
            XCTAssertEqual(weather.humidity, expectedWeather.humidity)
        }
    }
    
    func test_loadTaiwanWeather_withError() {
        let useCaseError = WeatherUseCaseError.useCaseError
        let expectedError = WeatherViewModelError.viewModelError
        expect(withUseCaseResult: .failure(useCaseError)) { receivedError in
            XCTAssertEqual(receivedError, expectedError)
        }
    }
}

private extension WeatherViewModelTests {
    class UseCaseSpy: WeatherUseCaseProtocol {
        
        var completions: [((Result<Foodpanda.Weather, Foodpanda.WeatherUseCaseError>) -> Void)] = []
        
        func loadWeather(fromCountry country: String, OnDate date: String, completionForViewModel: @escaping ((Result<Foodpanda.Weather, Foodpanda.WeatherUseCaseError>) -> Void)) {
            completions.append(completionForViewModel)
        }
        
        func complete(withWeather weather: Weather, atIndex index: Int = 0) {
            completions[index](.success(weather))
        }
        
        func complete(withUseCaseError error: WeatherUseCaseError, atIndex index: Int = 0) {
            completions[index](.failure(error))
        }
    }
    
    func makeSUT() -> (WeatherViewModel, UseCaseSpy) {
        let spy = UseCaseSpy()
        let viewModel = WeatherViewModel(useCase: spy)
        return (viewModel, spy)
    }
    
    func expect(withUseCaseResult useCaseResult: Result<Weather, WeatherUseCaseError>, successfulAction: ((Weather) -> Void)? = nil, failureAction: ((WeatherViewModelError) -> Void)? = nil) {
        let (sut, spy) = makeSUT()
        sut.loadTaiwanWeather()
        let expectation = expectation(description: "Wait for completion...")
        sut.weatherDidUpdate = { weather in
            expectation.fulfill()
            successfulAction?(weather)
        }
        sut.errorDidUpdate = { error in
            expectation.fulfill()
            failureAction?(error)
        }
        
        switch useCaseResult {
        case .success(let weather):
            spy.complete(withWeather: weather)
        case .failure(let useCaseError):
            spy.complete(withUseCaseError: useCaseError)
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
