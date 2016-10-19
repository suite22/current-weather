//
//  APIClient.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/18/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import Foundation

enum APIError: Error {
    case createRequest(String)
}

class APIClient {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func fetchWeather(request: APIRequest, completion: @escaping (WeatherModel?, Error?) -> Void) {
        guard let weatherRequest = request.weatherRequest() else {
            completion(nil, APIError.createRequest("Failed to create the weather request."))
            return
        }
        
        let task = session.dataTask(with: weatherRequest, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print("Got error response:", error)
                completion(nil, error)
                return
            }
            
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Printing JSON:", json)
                if let json = json {
                    if let weather = WeatherModel(json: json) {
                        completion(weather, nil)
                    }
                }
            }
        })
        
        task.resume()
    }
}
