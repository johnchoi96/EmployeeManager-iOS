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
        
        // add employee annotation
        addEmployeeAnnotation()
        
        mapView.showsUserLocation = true
        
        // get current location
        locationManager.delegate = self
        
        let permissionStatus = CLLocationManager.authorizationStatus()
        switch permissionStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            fallthrough
        case .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
     Retrieves the coordinate with the physical address and make MKPointAnnotation and add it to the map view.
     */
    private func addEmployeeAnnotation() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address.fullAddress) { (placemarks, err) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                let alert = UIAlertController(title: "Error while retrieving location", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }

            let annotation = MKPointAnnotation()
            annotation.title = self.employeeName
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    /**
     Makes an annotation based on the current location of the device and adds to the map view.
     - Parameter location: current location reported by CLLocationManager.
     */
    private func addCurrentLocationAnnotation(_ location: CLLocation?) {
        // make current location annotation
        let annotation = MKPointAnnotation()
        annotation.subtitle = "Current Location"
        guard let coordinate = location?.coordinate else {
            return
        }
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}

// MARK: - CLLocationManager delegate section
extension AddressViewController: CLLocationManagerDelegate {
    
    /**
     When the current location information is retrieved, the current location is displayed on the map.
     This annotation is created and displayed on the map.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        // get current location
        mapView.showsUserLocation = true
        self.addCurrentLocationAnnotation(locations.first)
    }
}
