//
//  WeatherViewModel.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/25.
//

import Foundation

enum WeatherViewModelError: Error {
    case viewModelError
}

class WeatherViewModel {
    
    let useCase: WeatherUseCase
    
    var weatherDidUpdate: ((Weather) -> Void)?
    var errorDidUpdate: ((WeatherViewModelError) -> Void)?
    
    init(useCase: WeatherUseCase) {
        self.useCase = useCase
    }
    
    func loadTaiwanWeather() {
        useCase.loadWeather(fromCountry: "taiwan", OnDate: "20240625") { result in
            switch result {
            case .success(let weather):
                self.weatherDidUpdate?(weather)
                
                
            case .failure(_):
                self.errorDidUpdate?(WeatherViewModelError.viewModelError)
            }
        }
    }
}
