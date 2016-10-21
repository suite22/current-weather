//
//  ViewController.swift
//  CurrentWeather
//
//  Created by Ben Goertz on 10/17/16.
//  Copyright © 2016 Ben Goertz. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    private var currentWeather: WeatherModel? {
        didSet {
            modelDidChange()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 3000
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("Authorized to use location")
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        default:
            print("Unable to use location services")
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func refreshWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let request = APIRequest(location: (lat, lon))
        let client = APIClient()
        client.fetchWeather(request: request, completion: { (model, error) -> Void in
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
        cityLabel.text = weather.locationName
        sunriseLabel.text = weather.sunrise
        sunsetLabel.text = weather.sunset
        descriptionLabel.text = weather.shortDescription
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed Captain!: ", error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // since they're returned in chronological order, we really just want the last one
        guard let location = locations.last else {
            print("Unable to get the most recent location from the locations array.")
            return
        }
        
        refreshWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

