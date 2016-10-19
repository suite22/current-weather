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
    
    let locationManager = CLLocationManager()
    
    // cLat and cLon should be set at the same time, so only using the didSet on cLat
    internal var cLat: CLLocationDegrees? {
        didSet {
            refreshWeather()
        }
    }
    internal var cLon: CLLocationDegrees?
    
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
        
        cLat = location.coordinate.latitude
        cLon = location.coordinate.longitude
    }
}

