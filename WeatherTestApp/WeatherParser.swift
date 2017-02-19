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
    
    init(data: Data) {
        super.init()
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
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
    }
}
