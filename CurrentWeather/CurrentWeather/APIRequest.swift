//
//  APIRequest.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/19/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import Foundation

typealias Location = (lat: Double, lon: Double)

struct APIRequest {
    
    private let baseURL: String = "http://api.openweathermap.org/data/2.5/weather?"
    private let units: String = "&units=imperial"
    private let apiKey: String = "&appid=16c64820094829d1e919d8ffa06d63ee" // TODO move to a plist
    
    var location: Location
    
    func weatherRequest() -> URLRequest? {
        let apiLat: String = "lat=\(location.lat)"
        let apiLon: String = "&lon=\(location.lon)"
        
        guard let url = URL(string: baseURL + apiLat + apiLon + units + apiKey) else {
            print("Failed to build request URL")
            return nil
        }
        return URLRequest(url: url)
    }
}
