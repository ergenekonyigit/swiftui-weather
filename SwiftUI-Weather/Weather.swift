//
//  Weather.swift
//  SwiftUI-Weather
//
//  Created by Ergenekon Yiğit on 31.01.2021.
//

import Foundation

public struct WeatherCurrent {
    let city: String
    let tempreture: String
    let minTemperature: String
    let maxTemperature: String
    let description: String
    let iconName: String
    
    init(response: APICurrentResponse) {
        city = response.name
        tempreture = "\(Int(response.main.temp))"
        minTemperature = "\(Int(response.main.temp_min))"
        maxTemperature = "\(Int(response.main.temp_max))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
}

public struct WeatherNextFive {
    let dts: [Int]
    let dayTemperatures: [String]
    let nightTemperatures: [String]
    let iconNames: [String]
    
    init(response: APINextFiveResponse) {
        dts = Array(response.daily.map { $0.dt }.prefix(5))
        dayTemperatures = Array(response.daily.map { "\(Int($0.temp.day))°" }.prefix(5))
        nightTemperatures = Array(response.daily.map { "\(Int($0.temp.night))°" }.prefix(5))
        iconNames = Array(response.daily.map { $0.weather.first?.iconName ?? "" }.prefix(5))
    }
}
