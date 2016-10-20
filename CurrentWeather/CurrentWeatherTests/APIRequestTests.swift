//
//  APIRequestTests.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/19/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import XCTest
@testable import CurrentWeather

class APIRequestTests: XCTestCase {
    
    func testWeatherRequestValid() {
        // given
        let expectedURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=45.5231&lon=-122.6765&units=imperial&appid=16c64820094829d1e919d8ffa06d63ee")
        let lat: Double = 45.5231
        let lon: Double = -122.6765
        
        // when 
        let request = APIRequest(location: (lat, lon))
        
        // then
        XCTAssertTrue(request.weatherRequest() == URLRequest(url: expectedURL!), "Expect weather request to match given URL.")
    }
}
