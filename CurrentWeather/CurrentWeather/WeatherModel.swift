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
    fileprivate let temperatureRaw: Double
    fileprivate let sunriseTime: Date
    fileprivate let sunsetTime: Date
    fileprivate let windSpeedRaw: Double
    fileprivate let windDirection: Double
    
    var temperature: String {
        return "\(lround(temperatureRaw))°"
    }
    
    var sunrise: String {
        return convert(date: sunriseTime)
    }
    
    var sunset: String {
        return convert(date: sunsetTime)
    }
    
    var windSpeed: String {
        return "\(round(windSpeedRaw)) mph"
    }
    
    /**
        Convert the date to a string that's presentable
     
        - parameter date: Date object to convert from
        - returns: Date string to be displayed
     */
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
            let description = weather[0]["description"] as? String,
            let wind = json["wind"] as? [String: Double],
            let windSpeed = wind["speed"],
            let windDirection = wind["deg"]
        else {
            print("Failed to init model with json.")
            return nil
        }
        
        self.temperatureRaw = temp
        self.locationName = name
        self.shortDescription = description.capitalized
        self.sunriseTime = Date(timeIntervalSince1970: TimeInterval(sunrise))
        self.sunsetTime = Date(timeIntervalSince1970: TimeInterval(sunset))
        self.windSpeedRaw = windSpeed
        self.windDirection = windDirection
    }
}
