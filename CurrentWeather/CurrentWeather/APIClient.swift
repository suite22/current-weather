//
//  APIClient.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/18/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import Foundation

enum APIError: Error {
    case createRequestFailed(String)
    case emptyDataResponse(String)
    case jsonDeserializeFailed(String)
}

class APIClient {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func fetchWeather(request: APIRequest, completion: @escaping (WeatherModel?, Error?) -> Void) {
        guard let weatherRequest = request.weatherRequest() else {
            completion(nil, APIError.createRequestFailed("Failed to create the weather request."))
            return
        }
        
        let task = session.dataTask(with: weatherRequest, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, APIError.emptyDataResponse("Data response nil."))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(nil, APIError.jsonDeserializeFailed("JSON deserialization failed."))
                return
            }
            
            print("Printing JSON:", json)
            if let json = json {
                if let weather = WeatherModel(json: json) {
                    completion(weather, nil)
                }
            }
        })
        task.resume()
    }
}
