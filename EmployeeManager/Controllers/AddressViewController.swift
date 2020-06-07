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
    
    @IBOutlet weak var streetTitleLabel: UILabel!
    @IBOutlet weak var street1TitleLabel: UILabel!
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var stateTitleLabel: UILabel!
    @IBOutlet weak var zipTitleLabel: UILabel!
    
    var address: Address!
    var employeeName: String!
    
    let locationManager = CLLocationManager()
    
    private let YES = NSLocalizedString("Yes message", comment: "Yes button label for alert action")
    private let NO = NSLocalizedString("No message", comment: "No button label for alert action")
    private let OK = NSLocalizedString("OK message", comment: "OK button label for alert action")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyLocalization()
        
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
            let alert = UIAlertController(title: NSLocalizedString("location permission denied alert", comment: ""), message: NSLocalizedString("location permission denied alert message", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: YES, style: .default) { (handler) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: NO, style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        default:
            print("should not be here")
        }
    }
    
    private func applyLocalization() {
        streetTitleLabel.text = NSLocalizedString("street label", comment: "Street label")
        street1TitleLabel.text = NSLocalizedString("street 2 label", comment: "Street 1 label")
        cityTitleLabel.text = NSLocalizedString("city label", comment: "City label")
        stateTitleLabel.text = NSLocalizedString("state label", comment: "State label")
        zipTitleLabel.text = NSLocalizedString("zip label", comment: "Zip label")
    }
    
    /**
     Retrieves the coordinate with the physical address and make MKPointAnnotation and add it to the map view.
     */
    private func addEmployeeAnnotation() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address.fullAddress) { (placemarks, err) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                let alert = UIAlertController(title: NSLocalizedString("error getting location", comment: ""), message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: self.OK, style: .cancel, handler: nil)
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
        annotation.subtitle = NSLocalizedString("annotation current location", comment: "")
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
