//
//  AddressViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/30/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressViewController: UIViewController {

    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var optionalStreetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var optionalStreetStack: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    var address: Address!
    var employeeName: String!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        streetLabel.text = address.street
        if let secondStreet = address.street1 {
            optionalStreetStack.isHidden = false
            optionalStreetLabel.text = secondStreet
        }
        cityLabel.text = address.city
        stateLabel.text = address.state
        zipLabel.text = address.zip
        
        mapView.showsUserLocation = true
        
        // get current location
        locationManager.delegate = self
        
        let permissionStatus = CLLocationManager.authorizationStatus()
        switch permissionStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            fallthrough
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            mapView.showsUserLocation = false
            let alert = UIAlertController(title: "Location permission denied.", message: "Would you like to manually approve?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) { (handler) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        default:
            print("should not be here")
        }
    }
    
    /**
     Makes an annotation for the map view using the physical address and the tag name.
     Adds the generated annotation to the self.mapView.
     - Parameter address: Physical address for the annotation to be displayed on the map
     - Parameter tagName: Name of the annotation
     */
//    private func getAnnotation(address: String, tagName: String) {
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(address) { (placemarks, error) in
//            guard let placemarks = placemarks, let location = placemarks.first?.location else {
//                let alert = UIAlertController(title: "Error while retrieving location", message: "", preferredStyle: .alert)
//                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alert.addAction(action)
//                self.present(alert, animated: true, completion: nil)
//                return
//            }
//            let lat = location.coordinate.latitude
//            let long = location.coordinate.longitude
//            let clLocation = CLLocation(latitude: lat, longitude: long)
//            // make annotation
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = clLocation.coordinate
//            annotation.title = tagName
//            self.mapView.addAnnotation(annotation)
////            self.mapView.centerToLocation(clLocation)
//        }
//    }
    
    /**
     Makes an annotation for the map view using the coordinate passed in.
     If the coordinate is nil, MKPointAnnotation with nil is returned.
     - Parameter coordinate: coordinate of the annotation
     - Returns: annotation generated with the coordinate passed in, nil if the coordinate was invalid
     */
//    private func getAnnotation(coordinate: CLLocationCoordinate2D?) -> MKPointAnnotation? {
//        var annotation: MKPointAnnotation?
//        if let coordinate = coordinate {
//            annotation = MKPointAnnotation()
//            annotation!.coordinate = coordinate
//        }
//        return annotation
//    }
}

// MARK: - CLLocationManager delegate section
extension AddressViewController: CLLocationManagerDelegate {
    
    /**
     When the current location information is retrieved, two annotations are acquired:
     1. Employee
     2. Current location
     These annotations are created and shown on the map.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        // get current location
        mapView.showsUserLocation = true
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address.fullAddress) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                let alert = UIAlertController(title: "Error while retrieving location", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let initialLocation = CLLocation(latitude: lat, longitude: long)
            self.mapView.centerToLocation(initialLocation)
            // make annotation for employee
            let employeeAnnotation = MKPointAnnotation()
            employeeAnnotation.coordinate = location.coordinate
            employeeAnnotation.title = self.employeeName
            // make current location annotation
            let currentLocationAnnotation = MKPointAnnotation()
            currentLocationAnnotation.coordinate = (locations.first?.coordinate)!
            self.mapView.showAnnotations([currentLocationAnnotation, employeeAnnotation], animated: true)
        }
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
//    func centerToLocation(_ location: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000) {
//        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        setRegion(coordinateRegion, animated: true)
//    }
}
