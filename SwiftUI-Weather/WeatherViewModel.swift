//
//  WeatherViewModel.swift
//  SwiftUI-Weather
//
//  Created by Ergenekon Yiğit on 31.01.2021.
//

import Foundation

extension Date {
    func shortDayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).prefix(3).uppercased()
    }
}

private let defaultIcon = "plus.circle.fill"
private let iconMap = [
    "01d": "sun.max.fill",
    "01n": "moon.fill",
    "02d": "cloud.sun.fill",
    "02n": "cloud.moon.fill",
    "03d": "cloud.fill",
    "03n": "cloud.fill",
    "04d": "smoke.fill",
    "04n": "smoke.fill",
    "09d": "cloud.heavyrain.fill",
    "09n": "cloud.heavyrain.fill",
    "10d": "cloud.sun.rain.fill",
    "10n": "cloud.moon.rain.fill",
    "11d": "cloud.bolt.fill",
    "11n": "cloud.bolt.fill",
    "13d": "snow",
    "13n": "snow",
    "50d": "cloud.fog.fill",
    "50n": "cloud.fog.fill",
]

struct DailyWeather: Identifiable {
    var id = UUID()
    var dayOfWeek: String
    var dayTemperature: String
    var nightTemperature: String
    var weatherIcon: String
}

public class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var minMaxTemperature: String = "H:-° L:-°"
    @Published var weatherDescription: String = ""
    @Published var weatherIcon: String = defaultIcon
    
    @Published var dailyWeather: [DailyWeather] = Array(repeating: DailyWeather.init(dayOfWeek: "--",
                                                                                     dayTemperature: "--",
                                                                                     nightTemperature: "--",
                                                                                     weatherIcon: defaultIcon),
                                                        count: 5)
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    public func refresh() {
        weatherService.loadCurrentDayWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.tempreture)°C"
                self.minMaxTemperature = "H:\(weather.maxTemperature)° L:\(weather.minTemperature)°"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
        
        weatherService.loadNextFiveDaysWeatherData { weather in
            DispatchQueue.main.async {
                // FIX: imperative block
                for index in (0 ..< 5) {
                    // FIX: dayOfWeek function
                    self.dailyWeather[index] = DailyWeather.init(dayOfWeek: DateFormatter()
                                                                        .weekdaySymbols[Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: TimeInterval(weather.dts[index])))]
                                                                        .prefix(3).uppercased(),
                                                                 dayTemperature: weather.dayTemperatures[index],
                                                                 nightTemperature: weather.nightTemperatures[index],
                                                                 weatherIcon: iconMap[weather.iconNames[index]] ?? defaultIcon)
                }
            }
        }
    }
}
