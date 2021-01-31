//
//  WeatherService.swift
//  SwiftUI-Weather
//
//  Created by Ergenekon Yiğit on 30.01.2021.
//

import CoreLocation
import Foundation

public final class WeatherService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let API_KEY = "0ea660054b3a0fcb45a21ad7878fc17b"
    private var completionHandlerCurrent: ((WeatherCurrent) -> Void)?
    private var completionHandlerNextFive: ((WeatherNextFive) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadCurrentDayWeatherData(_ completionHandlerCurrent: @escaping((WeatherCurrent) -> Void)) {
        self.completionHandlerCurrent = completionHandlerCurrent
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public func loadNextFiveDaysWeatherData(_ completionHandlerNextFive: @escaping((WeatherNextFive) -> Void)) {
        self.completionHandlerNextFive = completionHandlerNextFive
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func makeCurrentDayDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=metric&appid=\(API_KEY)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(APICurrentResponse.self, from: data) {
                self.completionHandlerCurrent?(WeatherCurrent(response: response))
            }
        }.resume()
    }
    
    private func makeNextFiveDaysDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=metric&exlude=current,minutely,hourly,alerts&appid=\(API_KEY)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(APINextFiveResponse.self, from: data) {
                self.completionHandlerNextFive?(WeatherNextFive(response: response))
            }
        }.resume()
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        makeCurrentDayDataRequest(forCoordinates: location.coordinate)
        makeNextFiveDaysDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}

// Current Day
struct APICurrentResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

// Next Five Days
struct APINextFiveResponse: Decodable {
    let daily: [APIDaily]
}

struct APITemp: Decodable {
    let day: Double
    let night: Double
}

struct APIDaily: Decodable {
    let dt: Int
    let temp: APITemp
    let weather: [APIWeather]
}

// shared
struct APIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "icon"
    }
}
