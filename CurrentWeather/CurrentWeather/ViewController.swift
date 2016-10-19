//
//  ViewController.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/17/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentTempLabel: UILabel!
    
    private var currentWeather: WeatherModel? {
        didSet {
            modelDidChange()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func refreshWeather() {
        let client = APIClient()
        client.fetchWeather(location: ("", ""), completion: { (model, error) -> Void in
            DispatchQueue.main.async {
                self.currentWeather = model
            }
        })
    }
    
    func modelDidChange() {
        guard let weather = currentWeather else {
            print("Failed to load model.")
            return
        }
        
        let tempRounded = round(weather.temperature)
        currentTempLabel.text = "\(tempRounded)°"
    }
}

