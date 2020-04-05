//
//  WeatherVC.swift
//  Clima
//
//  Created by Apple on 30/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // to ask for permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
       
        txtSearch.delegate = self
        weatherManager.delegate = self
    }
    
    @IBAction func btnLocation_clk(_ sender: UIButton) {
        
         locationManager.requestLocation()
        
    }
    
}
//MARK: - UITextfieldDelegate

extension WeatherVC : UITextFieldDelegate{
    
    @IBAction func btnSearch_clk(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if txtSearch.text != ""{
            return true
        }else{
            textField.placeholder = "Type Something here.."
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = txtSearch.text{
            weatherManager.fetchWeather(cityName: city)
            
        }
        
        txtSearch.text = ""
        
    }
}

//MARK: - weatherManagerDelegate


extension WeatherVC : weatherManagerDelegate{
    
    
    func didUpdateWeather(_ weatherManager : WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate

extension WeatherVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat, longitude : lon)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
