//
//  WeatherModel.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/18/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import Foundation

struct WeatherModel {
    let temperature: Double
    
}

extension WeatherModel {
    init?(json: [String: Any]) {
        guard let main = json["main"] as? [String: Double],
            let temp = main["temp"]
        else {
            return nil
        }
        
        self.temperature = temp
    }
}