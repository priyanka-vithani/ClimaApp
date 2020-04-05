//
//  WeatherManager.swift
//  Clima
//
//  Created by Apple on 31/03/20.
//  Copyright © 2020 Apple. All rights reserved.
// &q=london

import Foundation
import CoreLocation
protocol weatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager,weather: WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=9379ed0f722bc4d7976c4f1d5de4be00&units=metric"
    var delegate : weatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let strURL = "\(weatherURL)&q=\(cityName)"
        print(strURL)
        performRequest(with: strURL)
    }
    
    func fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees){
        let strURL = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(strURL)
        performRequest(with: strURL)
    }
    
    func performRequest(with urlString : String){
        //1. Create url
        
        if let url = URL(string: urlString){
            //2. Crteate url sassion
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Starts the task
            task.resume()
        }
        
    }
    func parseJSON(_ weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
          let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
       
    }
   
}
