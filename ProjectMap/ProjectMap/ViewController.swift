//
//  ViewController.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 25/09/2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var markerButton: UIButton!
    @IBOutlet var mapView: GMSMapView!
    
    var marker: GMSMarker?
    var locationManager: CLLocationManager?
    var setMarker: Bool = true // для разрешения установки маркеров
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configMap()
        configLocationManager()
    }

    func configMap() {
        mapView.setMinZoom(15, maxZoom: 16)
    }
    
    func configLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    
    @IBAction func markerActionButton(_ sender: Any) { // кнопка для вкл/выкл установки маркеров
        switchSetMarker()
    }
    
    func switchSetMarker() {
        if setMarker == true {
            setMarker = false
        }
        else {
            setMarker = true
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            if setMarker == true { // проверка разрешения на установку маркера
                let marker = GMSMarker(position: location.coordinate)
                marker.map = mapView
                self.marker = marker
            }
            
            mapView.animate(toLocation: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

