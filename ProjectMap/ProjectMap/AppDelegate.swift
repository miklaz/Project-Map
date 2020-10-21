//
//  AppDelegate.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 25/09/2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyBYO_jJYjF6EnHl8hN_QsSKxBjcwqtUI3c")    //  Ключ для GMaps
        
        let center = UNUserNotificationCenter.current() //  Получение разрешения на отправку уведомлений
        center.requestAuthorization(options: [.alert, .badge,.sound]) { (granted, error) in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            self.sendNotificatioRequest(
                content: self.makeNotificationContent(),
                trigger: self.makeIntervalNotificatioTrigger()
            )
        }
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                print("Пользователь ещё не выбирал отправлять ли ему уведомления.")
            case .denied:
                print("Разрешения на отправку уведомлений НЕТ!")
            case .authorized:
                print("Разрешение на отправку уведомлений ЕСТЬ!")
            default: break
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    
    // MARK: - Notifications
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()    //  Настройка самого уведомления
        content.title = "Возвращайся!"
        content.body = "Тут можно открыть крату, а так же посмотреть свой пройденый маршрут!"
        content.badge = 1   //  Наклейка с кол-м уведомлений
        return content
    }
    
    func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: 60,   //  Кол-во секунд до показа уведомления
            repeats: false
        )
    }

    func sendNotificatioRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
        
        let request = UNNotificationRequest(    //  Запрос на показ уведомления
            identifier: "alaram",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current() //  Добавление запроса в центр уведомлений
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    
}

