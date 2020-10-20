//
//  LocationManager.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 20.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import Foundation
import GooglePlaces
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    static let instance = LocationManager()
    
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    let locationManager = CLLocationManager()
    
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    // Начать отслеживать геопозицию.
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func configureLocationManager() {
        // Устанавливаем делегат.
        locationManager.delegate = self
        // Разрешить обновление геолокации в фоновом режиме.
        locationManager.allowsBackgroundLocationUpdates = true
        // Не останавливать определение локации, если приложение находится в фоне и телефон некоторое время не меняет местоположения.
        locationManager.pausesLocationUpdatesAutomatically = false
        // Запускать приложение при перемещении устройства на 500 метров и более.
        locationManager.startMonitoringSignificantLocationChanges()
        // Точность геолокации.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Минимальная дистанция (в метрах), на которую должно быть перемещено устройство для обновления данных.
        locationManager.distanceFilter = 10
        // Запросим разрешения на работу геолокации в фоне.
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
