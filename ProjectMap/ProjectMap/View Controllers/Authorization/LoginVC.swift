//
//  LoginVC.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 14.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    
    
    // MARK: - Const, Var & Outlets
    var realm: Realm?
    var appSwitcherView: UIView?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    
    // MARK: - VС Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObservers()
        configureLoginBindings()
        
        /*if UserDefaults.standard.bool(forKey: "isLogin") {  // Если пользователь авторизован
            performSegue(withIdentifier: "toMap", sender: self)
        }*/
    }
    
    
    // MARK: - Methods
    func showMassage(_ massage: String) {   //  Выводит сообщения в виде alert
        let alert = UIAlertController(title: massage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // Настройка биндингов
    func configureLoginBindings() {
        _ = Observable
            // Объединяем два обсервера в один
            .combineLatest(
                // Обсервер изменения текста
                loginTextField.rx.text,
                // Обсервер изменения текста
                passwordTextField.rx.text
            )
            // Модифицируем значения из двух обсерверов в один
            .map { login, password in
                // Если введены логин и пароль больше 6 символов, будет возвращено “истина”
                return !(login ?? "").isEmpty && !(password ?? "").isEmpty
            }
            // Подписываемся на получение событий
            .bind { [weak loginButton] inputFilled in
                // Если событие означает успех, активируем кнопку, иначе деактивируем
                loginButton?.isEnabled = inputFilled
            }
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
    @IBAction func login(_ sender: Any) {   //  Вход
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            self.realm = realm
        } catch {
            print(error)
        }
        
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text,
            let user = realm?.objects(User.self).filter("login = '\(login)' AND password = '\(password)'"),
            !user.isEmpty
        else {
            showMassage("Пользователя с таким логином и паролем не существует!")
            return
        }

        UserDefaults.standard.set(true, forKey: "isLogin")  //  Флаг авторизации
        performSegue(withIdentifier: "toMap", sender: sender)
    }
    
    @IBAction func registration(_ sender: Any) {        //  Переход на экран регистрации
        performSegue(withIdentifier: "toRegistration", sender: sender)
    }
    
    @IBAction func rememberPassword(_ sender: Any) {    //  Переход на экран восстановления пароля
        performSegue(withIdentifier: "toMemento", sender: sender)
    }
    
    //  Копирует адрес файла Realm и удаляет лишние символы для корректной вставки в Finder
    @IBAction func copyRealmFileAdress(_ sender: Any) {
        
        var realmFileAdress: String = "\(Realm.Configuration.defaultConfiguration.fileURL!)"
        let range = realmFileAdress.index(realmFileAdress.startIndex, offsetBy: 0)..<realmFileAdress.index(realmFileAdress.startIndex, offsetBy: 7)
        realmFileAdress.removeSubrange(range)
        
        UIPasteboard.general.string = realmFileAdress
        
        showMassage("Ссылка на файл Realm скопирована в буфер обмена!")
    }
    

}
