//
//  APIClient.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/18/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import Foundation

class APIClient {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let request = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=45&lon=122&appid=16c64820094829d1e919d8ffa06d63ee")!)
    
    func fetchWeather(location: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print("Got error response:", error)
                completion(nil, error)
                return
            }
            
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Printing JSON:", json)
            }
            completion(data, nil)
        })
        
        task.resume()
    }
}
