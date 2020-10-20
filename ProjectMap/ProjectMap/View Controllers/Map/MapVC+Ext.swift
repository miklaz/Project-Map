//
//  MapVC+Ext.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 13.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        mapView.animate(toLocation: location.coordinate)
    }
    
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
    }
}
