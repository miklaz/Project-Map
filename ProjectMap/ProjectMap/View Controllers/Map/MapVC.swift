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
import RealmSwift

class MapVC: UIViewController {
    
    
    // MARK: - Const, Var & Outlets
    var currentLocation: CLLocation?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var locationManager: CLLocationManager?
    var tracker: Bool = false // Для переключения состояния трекинга
    
    @IBOutlet var watchLastRouteButton: UIButton!
    @IBOutlet var switchMyLocationButton: UIButton!
    @IBOutlet var switchTrafficButton: UIButton!
    @IBOutlet var routeTrackingButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.delegate = self
            mapView.isTrafficEnabled = true
            mapView.isMyLocationEnabled = true
            mapView.settings.compassButton = true
        }
    }
    
    
    // MARK: - VС Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configMap()
        configLocationManager()
    }
    
    
    // MARK: - Methods
    func configMap() {  //  Стартовая настойка карты
        mapView.setMinZoom(15, maxZoom: 17)
        
        do {    // Удаление маршрута с предыдущего запуска
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
    
    func configLocationManager() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
    }
    
    func addLastRoute() {   //  Сохранение маршрута в Realm
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
            realm.beginWrite()
            guard let routePath = routePath else { return }
            for i in 0..<routePath.count() {
                let lastRoute = LastRoute()
                let currentCoordinate = routePath.coordinate(at: i)
                lastRoute.latitude = currentCoordinate.latitude
                lastRoute.longitude = currentCoordinate.longitude

                realm.add(lastRoute)
            }
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func lastRoute() {  //  Показ предыдущего маршрута
        let realm = try! Realm()
        let lastRoute: Results<LastRoute> = { realm.objects(LastRoute.self) }()
        guard !lastRoute.isEmpty else { return }
        
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        route?.strokeWidth = 5
        route?.strokeColor = .systemRed

        for coordinates in lastRoute {
            routePath?.add(CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))
            route?.path = routePath
        }
        
        let firstCoordinates = CLLocationCoordinate2D(latitude: lastRoute.first!.latitude, longitude: lastRoute.first!.longitude)
        let lastCoordinates = CLLocationCoordinate2D(latitude: lastRoute.last!.latitude ,longitude: lastRoute.last!.longitude)
        let bounds = GMSCoordinateBounds(coordinate: firstCoordinates, coordinate: lastCoordinates)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
        
        mapView.camera = camera
        mapView.animate(with: GMSCameraUpdate.zoomOut())
    }
    
    func startTracking () {     //  Начало отслеживания маршрута
        tracker = true
        
        routeTrackingButton.backgroundColor = .red
        routeTrackingButton.setTitle("Остановить", for: .normal)
        watchLastRouteButton.setImage(UIImage(systemName: "backward"), for: .normal)
        
        mapView.clear()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        route?.strokeWidth = 3
        route?.strokeColor = .systemBlue
        locationManager?.startUpdatingLocation()
    }
    
    func finishTracking () {    //  Конец отслеживания маршрута
        tracker = false
        
        routeTrackingButton.backgroundColor = .systemBlue
        routeTrackingButton.setTitle("Отслеживать", for: .normal)
        
        locationManager?.stopUpdatingLocation()
        mapView.clear()
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
        addLastRoute()
    }
    
    
    // MARK: - IBActions
    @IBAction func switchTraffic(_ sender: Any) {   // Вкл/Выкл покзаз пробок
        if !mapView.isTrafficEnabled {
            switchTrafficButton.setImage(UIImage(systemName: "car.fill"), for: .normal)
            mapView.isTrafficEnabled = true
        } else {
            switchTrafficButton.setImage(UIImage(systemName: "car"), for: .normal)
            mapView.isTrafficEnabled = false
        }
    }
    
    @IBAction func switchMyLocation(_ sender: Any) {    // Вкл/Выкл показ текущего местоположения
        if !mapView.isMyLocationEnabled {
            switchMyLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
            mapView.isMyLocationEnabled = true
        } else {
            switchMyLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
            mapView.isMyLocationEnabled = false
        }
    }
    
    @IBAction func routeTracking(_ sender: Any) {   // Вкл/Выкл отслеживания маршрута
        if !tracker {
            startTracking()
        } else {
            finishTracking()
        }
    }
    
    @IBAction func watchLastRoute(_ sender: Any) {  // Показ предыдущего маршрута
        watchLastRouteButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        if tracker {
            finishTracking()
            lastRoute()
        } else {
            lastRoute()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
