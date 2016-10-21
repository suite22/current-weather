//
//  WeatherModel.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/18/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import Foundation

struct WeatherModel {
    let locationName: String
    let shortDescription: String
    fileprivate let temp: Double
    fileprivate let sunriseTime: Date
    fileprivate let sunsetTime: Date
    
    var temperature: String {
        return "\(lround(temp))°"
    }
    
    var sunrise: String {
        return convert(date: sunriseTime)
    }
    
    var sunset: String {
        return convert(date: sunsetTime)
    }
    
    private func convert(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm a"
        return dateFormat.string(from: date)
    }
}

extension WeatherModel {
    init?(json: [String: Any]) {
        guard let main = json["main"] as? [String: Double],
            let temp = main["temp"],
            let name = json["name"] as? String,
            let sys = json["sys"] as? [String: Any],
            let sunrise = sys["sunrise"] as? Int,
            let sunset = sys["sunset"] as? Int,
            let weather = json["weather"] as? [[String: Any]],
            let description = weather[0]["description"] as? String
        else {
            print("Failed to init model with json.")
            return nil
        }
        
        self.temp = temp
        self.locationName = name
        self.shortDescription = description.capitalized
        self.sunriseTime = Date(timeIntervalSince1970: TimeInterval(sunrise))
        self.sunsetTime = Date(timeIntervalSince1970: TimeInterval(sunset))
    }
}
