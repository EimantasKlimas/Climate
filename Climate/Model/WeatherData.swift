//
//  WeatherData.swift
//  Climate
//
//  Created by Eimantas Klimas on 2021-08-25.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
    
}
