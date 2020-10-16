//
//  MementoVC.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 15.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import RealmSwift

class MementoVC: UIViewController {

    
    // MARK: - Const, Var & Outlets
    var realm: Realm?
    var appSwitcherView: UIView?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // MARK: - VС Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
    }
    
    // MARK: - Blur View
    func addObservers() {   //  Подписка на уведомления.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(blurTextFields), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showTextFields), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func blurTextFields() {   //  Добавление размытия на основной View
        let screenshot = createScreenshotOfCurrentContext() ?? UIImage()
        let blurredScreenshot = applyBlurFilter(on: screenshot, withBlurFactor: 4.5)
        
        appSwitcherView = UIImageView(image: blurredScreenshot)
        guard appSwitcherView != nil else { return }
        self.view.addSubview(appSwitcherView!)
    }
    
    @objc func showTextFields() {   //  Убрать размытие
        appSwitcherView?.removeFromSuperview()
    }
    
    
    func createScreenshotOfCurrentContext() -> UIImage? {   //  Создаёт скриншот экрана.
        UIGraphicsBeginImageContext(self.view.bounds.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        view.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func applyBlurFilter(on image: UIImage, withBlurFactor blurFactor : CGFloat) -> UIImage? {  //  Применяет к изображению эффект размытия.
        guard let inputImage = CIImage(image: image) else {
            return nil
        }
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(blurFactor, forKey: kCIInputRadiusKey)
        guard let outputImage = blurFilter?.outputImage else {
            return nil
        }
        let context = CIContext()
        guard let cgiImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        let bluredImage = UIImage(cgImage: cgiImage)
        return bluredImage
    }
    
    
    // MARK: - IBActions
    @IBAction func rememberPassword(_ sender: Any) {
        do {
            let realm = try Realm()
            self.realm = realm
        } catch {
            print(error)
        }
        
        guard
            let email = emailTextField.text,
            let user = realm?.objects(User.self).filter("login = '\(email)'"),
            !user.isEmpty
        else {  //  Если такого пользователя нет в базе
            let alert = UIAlertController(title: "Пользователя с таким логином не существует!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        // Сообщение с паролем пользователю и выход
        let alert = UIAlertController(title: "Ваш пароль: \(user[0].password)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    

}
