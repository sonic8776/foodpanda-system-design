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
    
    let useCase: WeatherUseCaseProtocol
    
    var weatherDidUpdate: ((Weather) -> Void)?
    var errorDidUpdate: ((WeatherViewModelError) -> Void)?
    
    init(useCase: WeatherUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func loadTaiwanWeather() {
        let completion: ((Result<Weather, WeatherUseCaseError>) -> Void) = { result in
            switch result {
            case .success(let weather):
                self.weatherDidUpdate?(weather)
                
                
            case .failure(_):
                self.errorDidUpdate?(WeatherViewModelError.viewModelError)
            }
        }
        
        useCase.loadWeather(fromCountry: "taiwan", OnDate: "20240625", completionForViewModel: completion)
//        useCase.loadWeather(fromCountry: "taiwan", OnDate: "20240625") { result in
//            switch result {
//            case .success(let weather):
//                self.weatherDidUpdate?(weather)
//                
//                
//            case .failure(_):
//                self.errorDidUpdate?(WeatherViewModelError.viewModelError)
//            }
//        }
    }
}
