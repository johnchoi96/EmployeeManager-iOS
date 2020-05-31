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
        
        // get current location
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
            // make annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = self.employeeName
            // make current location annotation
            let currentLocationAnnotation = MKPointAnnotation()
            currentLocationAnnotation.coordinate = (self.locationManager.location?.coordinate)!
            self.mapView.showAnnotations([currentLocationAnnotation, annotation], animated: true)
        }
        
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
