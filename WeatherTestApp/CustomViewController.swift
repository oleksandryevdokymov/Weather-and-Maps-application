//
//  CustomViewController.swift
//  WeatherTestApp
//
//  Created by adminaccount on 2/16/17.
//  Copyright © 2017 Oleksandr. All rights reserved.
//

import UIKit
import MapKit

class CustomViewController: UIViewController {
    var viewController = ViewController()

    let session = URLSession(configuration: .default)
    var currentCoordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController.parseData(latitude: currentCoordinates.latitude,
                             longitude: currentCoordinates.longitude,
                             completionHandler: { (data) in
                                let parser = WeatherParser(data: data)
                                DispatchQueue.main.async {
                                    self.cityLabel.text = parser.cityName!
                                    self.temperatureLabel.text = String(parser.temperature!) + String(" °C")
                                    self.pressureLabel.text = String(parser.pressure!) + String(" hPa")
                                    self.humidityLabel.text = String(parser.humidity!) + String(" %")
                                    self.windSpeedLabel.text = String(parser.windSpeed!) + String(" m/s")
                                    self.windDirectionLabel.text = String(parser.windDirection!) + String(" °")
                                    self.cloudsLabel.text = String(parser.clouds!) + String(" %")
                                    self.weatherImageView.image = parser.weatherIcon
                                }
        })
    }
}
