//
//  WeatherAnnotation.swift
//  WeatherTestApp
//
//  Created by adminaccount on 2/14/17.
//  Copyright © 2017 Oleksandr. All rights reserved.
//

import UIKit
import MapKit

class TemperatureAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var color: UIColor = .green
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
}
