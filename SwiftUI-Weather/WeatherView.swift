//
//  WeatherView.swift
//  SwiftUI-Weather
//
//  Created by Ergenekon Yiğit on 30.01.2021.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                CityTextView(cityName: viewModel.cityName)
                
                MainWeatherStatusView(imageName: viewModel.weatherIcon,
                                      temperature: viewModel.temperature,
                                      description: viewModel.weatherDescription,
                                      minMaxTemperature: viewModel.minMaxTemperature)
                
                Spacer()
                
                HStack(spacing: 20) {
                    ForEach(viewModel.dailyWeather) { weather in
                        WeatherDayView(dayOfWeek: weather.dayOfWeek,
                                       imageName: weather.weatherIcon,
                                       dayTemperature: weather.dayTemperature,
                                       nightTemperature: weather.nightTemperature)
                    }
                }.padding(.bottom, 100)
                
            }.onAppear(perform: viewModel.refresh)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}

struct Day: Identifiable {
    var id = UUID()
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
}

var weatherData = [
    Day(dayOfWeek: "TUE", imageName: "cloud.sun.fill", temperature: 14),
    Day(dayOfWeek: "WED", imageName: "sun.max.fill", temperature: 20),
    Day(dayOfWeek: "THU", imageName: "wind.snow", temperature: 1),
    Day(dayOfWeek: "FRI", imageName: "sunset.fill", temperature: 4),
    Day(dayOfWeek: "SAT", imageName: "snow", temperature: -1),
]

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var dayTemperature: String
    var nightTemperature: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text(dayTemperature)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
            Text(nightTemperature)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct CityTextView: View {
    
    var cityName: String

    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: String
    var description: String
    var minMaxTemperature: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text(temperature)
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
            Text(description)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            Text(minMaxTemperature)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}
