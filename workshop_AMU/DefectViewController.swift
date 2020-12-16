//
//  DefectViewController.swift
//  workshop_AMU
//
//  Created by Sara Stojanoska on 12/15/20.
//  Copyright © 2020 Sara Stojanoska. All rights reserved.
//

import UIKit
import MapKit
var places = [Dictionary<String, String>()]
var activePlace = -1

class DefectViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var autoMechanic: UIButton!
    @IBOutlet weak var electrician: UIButton!
    @IBOutlet weak var plumber: UIButton!
    @IBAction func buttonPressed(_ sender: UIButton) {
        let activePosition = sender.tag - 1
        if activePosition == 0{
            electrician.isEnabled = false
            autoMechanic.isEnabled = false
        }
        else if activePosition == 1{
            plumber.isEnabled = false
            autoMechanic.isEnabled = false
        }
        else if activePosition == 2{
            electrician.isEnabled = false
            plumber.isEnabled = false
        }
    }
    @IBOutlet weak var defectTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let longpressGR = UILongPressGestureRecognizer(target: self, action: #selector(DefectViewController.longpress(gestureRecognizer:)))
        longpressGR.minimumPressDuration = 1
        map.addGestureRecognizer(longpressGR)
        
        if activePlace == -1{
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        else{
            if places.count > activePlace{
                if let name = places[activePlace]["name"]{
                    if let lat = places[activePlace]["lat"]{
                        if let lon = places[activePlace]["lon"]{
                            if let latitude = Double(lat){
                                if let longitude = Double(lon) {
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    self.map.setRegion(region, animated: true)
                                    let annotation = MKPointAnnotation()
                                    annotation.coordinate = coordinate
                                    annotation.title = name
                                    self.map.addAnnotation(annotation)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func longpress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            let newLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: { (placemarks,error) in
                if error != nil {
                    print(error!)
                }
                else{
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                    if title == "" {
                        title = "Added \(NSDate())"
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    self.map.addAnnotation(annotation)
                    places.append(["name": title, "lon": String(newCoordinate.longitude), "lat": String(newCoordinate.latitude)])
                }
            })
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func findMechanicPress(_ sender: Any) {
        if defectTextField.text == ""{
            displayAlert(title: "Error in form", message: "You must provide a defect comment")
        }
        else{
            self.performSegue(withIdentifier: "toMechanic", sender: self)
        }
    }
}
