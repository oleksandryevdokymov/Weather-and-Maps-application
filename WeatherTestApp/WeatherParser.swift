//
//  WeatherParser.swift
//  WeatherTestApp
//
//  Created by adminaccount on 2/14/17.
//  Copyright © 2017 Oleksandr. All rights reserved.
//

import UIKit

class WeatherParser: NSObject, XMLParserDelegate {
    var temperature: Double?
    var pressure: Double?
    var windSpeed: Double?
    var clouds: Double?
    var humidity: Double?
    var cityName: String?
    var windDirection: Double?
    var weatherIcon : UIImage?
    var iconDownloadCompletion : ((UIImage?) -> Void)?
    
    init(data: Data) {
        super.init()
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func  downloadConditionImage(urlTemplate : String) {
        guard let urlAllowed = urlTemplate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlAllowed) else {
                print("Not valid URL")
                return
        }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let downloadCompletion = self.iconDownloadCompletion {
                        downloadCompletion(UIImage(data: data!))
                    }
                    self.weatherIcon = UIImage(data: data!)
                }
            }
        })
        dataTask.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "temperature" {
            if let temperature = attributeDict["value"], let temperatureDouble = Double(temperature)  {
                self.temperature = temperatureDouble
            }
        }
        if elementName == "pressure" {
            if let pressure = attributeDict["value"], let pressureDouble = Double(pressure) {
                self.pressure = pressureDouble
            }
        }
        if elementName == "humidity" {
            if let humidity = attributeDict["value"], let humidityDouble = Double(humidity) {
                self.humidity = humidityDouble
            }
        }
        if elementName == "speed" {
            if let windSpeed = attributeDict["value"], let windspeedDouble = Double(windSpeed) {
                self.windSpeed = windspeedDouble
            }
        }
        if elementName == "city" {
            if let cityName = attributeDict["name"], let cityNameString = String(cityName) {
                self.cityName = cityNameString
            }
        }
        if elementName == "direction" {
            if let windDirection = attributeDict["value"], let windDirectionDouble = Double(windDirection) {
                self.windDirection = windDirectionDouble
            }
        }
        if elementName == "clouds" {
            if let clouds = attributeDict["value"], let cloudsDouble = Double(clouds) {
                self.clouds = cloudsDouble
            }
        }
        if elementName == "weather" {
            if let icon = attributeDict["icon"] {
                let iconUrl = "http://openweathermap.org/img/w/\(icon).png"
                downloadConditionImage(urlTemplate: iconUrl)
            }
        }
    }
}
