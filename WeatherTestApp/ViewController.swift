//
//  ViewController.swift
//  WeatherTestApp
//
//  Created by Oleksandr on 2/6/17.
//  Copyright © 2017 Oleksandr. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Parameters
    let locationManager = CLLocationManager()
    let session = URLSession(configuration: .default)
    let temperatureOverlay = MKTileOverlay(urlTemplate: "http://maps.owm.io:8099/5735d67f5836286b007625cd/{z}/{x}/{y}?hash=ba22ef4840c7fcb08a7a7b92bf80d1fc")
    let windOverlay = MKTileOverlay(urlTemplate: "http://maps.owm.io:8099/5735d67f5836286b0076267b/{z}/{x}/{y}?hash=e529bed414220dfa2559b17e3f5ca831")
    let precipitationOvarlay = MKTileOverlay(urlTemplate: "http://maps.owm.io:8099/57456d1237fb4e01009cbb17/{z}/{x}/{y}?hash=042a4b4c8ec6bc8392aabf46fa91003c")
    let pressureOvarlay = MKTileOverlay(urlTemplate: "http://maps.owm.io:8099/5837ee50f77ebe01008ef68d/{z}/{x}/{y}?hash=21d287b716923b9702c510cc84f0487a")
    
    var pressureButtonCenter: CGPoint!
    var presipitationButtonCenter: CGPoint!
    var mapButtonCenter: CGPoint!
    var temperatureButtonCenter: CGPoint!
    var windButtonCenter: CGPoint!
    var currentCoordinate: CLLocationCoordinate2D!
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var pressureButton: UIButton!
    @IBOutlet weak var presipitationButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var temperatureButton: UIButton!
    @IBOutlet weak var windButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentLocation()
        
        pressureButtonCenter = pressureButton.center
        presipitationButtonCenter = presipitationButton.center
        mapButtonCenter = mapButton.center
        temperatureButtonCenter = temperatureButton.center
        windButtonCenter = windButton.center
        
        pressureButton.center = moreButton.center
        presipitationButton.center = moreButton.center
        mapButton.center = moreButton.center
        temperatureButton.center = moreButton.center
        windButton.center = moreButton.center
        
        mapView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCustomVIew" {
            let customController = segue.destination as! CustomViewController
            customController.currentCoordinates = currentCoordinate
        }
    }
    
    @IBAction func moreClicked(_ sender: UIButton) {
        if moreButton.currentImage == #imageLiteral(resourceName: "moreButtonOff") {
            UIView.animate(withDuration: 0.3, animations: {
                self.pressureButton.alpha = 1
                self.presipitationButton.alpha = 1
                self.mapButton.alpha = 1
                self.temperatureButton.alpha = 1
                self.windButton.alpha = 1
                
                self.pressureButton.center = self.pressureButtonCenter
                self.presipitationButton.center = self.presipitationButtonCenter
                self.mapButton.center = self.mapButtonCenter
                self.temperatureButton.center = self.temperatureButtonCenter
                self.windButton.center = self.windButtonCenter
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.pressureButton.alpha = 0
                self.presipitationButton.alpha = 0
                self.mapButton.alpha = 0
                self.temperatureButton.alpha = 0
                self.windButton.alpha = 0
                
                self.pressureButton.center = self.moreButton.center
                self.presipitationButton.center = self.moreButton.center
                self.mapButton.center = self.moreButton.center
                self.temperatureButton.center = self.moreButton.center
                self.windButton.center = self.moreButton.center
            
            })
        }
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "moreButtonOn"), offImage: #imageLiteral(resourceName: "moreButtonOff"))
    }
    
    @IBAction func pressureClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "pressureButtonOn"), offImage: #imageLiteral(resourceName: "pressureButtonOff"))
        if pressureButton.currentImage == #imageLiteral(resourceName: "pressureButtonOn") {
            mapView.add(pressureOvarlay)
        } else {
            mapView.remove(pressureOvarlay)
        }
    }
    
    @IBAction func precipitationClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "precipitationButtonOn"), offImage: #imageLiteral(resourceName: "precipitationButtonOff"))
        if presipitationButton.currentImage == #imageLiteral(resourceName: "precipitationButtonOn") {
            mapView.add(precipitationOvarlay)
        } else {
            mapView.remove(precipitationOvarlay)
        }
    }
    
    @IBAction func mapClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "mapButtonOn"), offImage: #imageLiteral(resourceName: "mapButtonOff"))
        if mapButton.currentImage == #imageLiteral(resourceName: "mapButtonOn") {
            setCurrentLocation()
        }
    }
    
    @IBAction func temperatureClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "temperatureButtonOn"), offImage: #imageLiteral(resourceName: "temperatureButtonOff"))
        if temperatureButton.currentImage == #imageLiteral(resourceName: "temperatureButtonOn") {
            mapView.add(temperatureOverlay)
        } else {
            mapView.remove(temperatureOverlay)
        }
    }
    
    @IBAction func windClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "windButtonOn"), offImage: #imageLiteral(resourceName: "windButtonOff"))
        if windButton.currentImage == #imageLiteral(resourceName: "windButtonOn") {
            mapView.add(windOverlay)
        } else {
            mapView.remove(windOverlay)
        }
    }
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) {
        if button.currentImage == offImage {
            button.setImage(onImage, for: .normal)
        } else {
            button.setImage(offImage, for: .normal)
        }
    }
    
    func setCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func parseTemperatureData(latitude: Double, longitude: Double, completionHandler: @escaping (_ data: Data) -> Void ) {
        let string = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&mode=xml&APPID=29a9f3444c733ccb3d08150e11240799"
        let url = URL(string: string)
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completionHandler(data!)
                }
            }
        })
        dataTask.resume()
    }
   
    var tempTitle: String!
    
    @IBAction func handleTap(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        parseTemperatureData(latitude: coordinate.latitude,
                             longitude: coordinate.longitude,
                             completionHandler: { (data) in
                                let parser = WeatherParser(data: data)
                                let annotation = TemperatureAnnotation(title: String(format: "%@", parser.cityName!), subtitle: String(format: "%g °C", parser.temperature!), coordinate: coordinate)
                                //annotation.color = .green
                                DispatchQueue.main.async {
                                    self.mapView.addAnnotation(annotation)
                                }
        })
    }
    
    @IBAction func removeAnnotation(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
    }
    @IBAction func mapChenges(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = MKMapType.standard
        } else if sender.selectedSegmentIndex == 1 {
            mapView.mapType = MKMapType.satellite
        } else if sender.selectedSegmentIndex == 2 {
            mapView.mapType = MKMapType.hybrid
        }
    }
    
    //MARK: - Location Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //set current location
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        //pin to current location
        let currentCoordinate = locations[0].coordinate
        let latitude = currentCoordinate.latitude
        let longitude = currentCoordinate.longitude
        self.locationManager.stopUpdatingLocation()
        parseTemperatureData(latitude: latitude,
                             longitude: longitude,
                             completionHandler: { (data) in
                                let parser = WeatherParser(data: data)
                                let annotation = TemperatureAnnotation(title: String(format: "%@", parser.cityName!), subtitle: String(format: "%g hPa", parser.pressure!), coordinate: currentCoordinate)
                                //annotation.color = .green
                                DispatchQueue.main.async {
                                    self.mapView.addAnnotation(annotation)
                                }
        })

    }
    //delegate mothod for using plygons
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKTileOverlay {
            let render = MKTileOverlayRenderer(tileOverlay: overlay)
            return render
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        currentCoordinate = view.annotation?.coordinate
        performSegue(withIdentifier: "segueToCustomVIew", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? TemperatureAnnotation {
            let identifier = "Pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -8, y: -5)
                view.pinTintColor = annotation.color
                //view.animatesDrop = true
                //view.image = UIImage(named: "mapButtonOff.png")
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
            }
            return view
        }
        return nil
    }
    
}
