//
//  MapViewController.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 28/08/23.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet private weak var mapView: GMSMapView!
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private var preciseLocationZoomLevel: Float = 15.0
    private var approximateLocationZoomLevel: Float = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocation()
    }
    
    func initializeLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

}

// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location: CLLocation = locations.last {
            let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
            print("Current Location is \(location.coordinate.latitude) , \(location.coordinate.longitude)")
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
                mapView.animate(to: camera)
            } else {
                mapView.animate(to: camera)
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

