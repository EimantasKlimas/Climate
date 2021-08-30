//
//  WeatherManager.swift
//  Climate
//
//  Created by Eimantas Klimas on 2021-08-25.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFail(with error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=b1b11973505334d748f3cd06890bb43d&units=metric"
    
    func fetchWeather(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        
        performRequest(with :urlString)
    }
    
    func fetchWeather(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lattitude)&lon=\(longitude)"
        
        performRequest(with :urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
        
        let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFail(with: error!)
                    return
                }
                
                if let safeData = data {
                    if let weatherData = parseWeatherData(weatherData: safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weatherData)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseWeatherData(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            delegate?.didFail(with: error)
            return nil
        }
    }
    
}
