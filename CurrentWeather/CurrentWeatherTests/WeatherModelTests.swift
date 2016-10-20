//
//  WeatherModelTests.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/19/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import XCTest
@testable import CurrentWeather

class WeatherModelTests: XCTestCase {
    
    func testModelParses() {
        // given
        let filePath = Bundle.main.path(forResource: "weatherModelJsonTestBlob", ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try! Data(contentsOf: fileURL)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        // when
        let model = WeatherModel(json: json!)
        
        // then
        XCTAssertTrue(model?.temperature == 57.75, "Expect temperature to match json test payload.")
    }
}
