//
//  SwiftUI_WeatherApp.swift
//  SwiftUI-Weather
//
//  Created by Ergenekon Yiğit on 30.01.2021.
//

import SwiftUI

@main
struct SwiftUI_WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            
            WeatherView(viewModel: viewModel)
        }
    }
}
