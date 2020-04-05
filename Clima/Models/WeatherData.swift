//
//  WeatherData.swift
//  Clima
//
//  Created by Apple on 31/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
struct WeatherData:Codable {
    var name : String
    let main : Main
    let weather : [Weather]
}
struct Main:Codable {
    let temp : Double
}
struct Weather:Codable {
    let description : String
    let id : Int
}
