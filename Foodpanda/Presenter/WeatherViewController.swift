//
//  WeatherViewController.swift
//  Foodpanda
//
//  Created by Judy Tsai on 2024/6/25.
//

import UIKit

class WeatherViewController: UIViewController {
    
    lazy var temperatureLabel = makeLabel()
    lazy var humidityLabel = makeLabel()
    lazy var loadWeatherButton = makeButton()
    let viewModel = WeatherFactory.makeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.weatherDidUpdate = { [weak self] weather in
            self?.temperatureLabel.text = String(weather.temperature)
            self?.humidityLabel.text = String(weather.humidity)
        }
        
        viewModel.errorDidUpdate = { error in
            // error handling
        }
    }
    
    func setupUI() {
        
    }
    
    @objc
    func buttonPressed() {
        viewModel.loadTaiwanWeather()
    }
}

private extension WeatherViewController {
    func makeLabel() -> UILabel {
        let label = UILabel()
        return label
    }
    
    func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }
}
