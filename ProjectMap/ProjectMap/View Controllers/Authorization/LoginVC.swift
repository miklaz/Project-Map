//
//  LoginVC.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 14.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import RealmSwift

class LoginVC: UIViewController {
    
    
    // MARK: - Const, Var & Outlets
    var realm: Realm?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - VС Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLogin") {  // Если пользователь авторизован
            performSegue(withIdentifier: "toMap", sender: self)
        }
    }
    
    
    // MARK: - Methods
    func showMassage(_ massage: String) {   //  Выводит сообщения
        let alert = UIAlertController(title: massage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - IBActions
    @IBAction func login(_ sender: Any) {   // Вход
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
    
    @IBAction func registration(_ sender: Any) {        // Переход на экран регистрации
        performSegue(withIdentifier: "toRegistration", sender: sender)
    }
    
    @IBAction func rememberPassword(_ sender: Any) {    // Переход на экран восстановления пароля
        performSegue(withIdentifier: "toMemento", sender: sender)
    }
    
    // Копирует адрес файла Realm и удаляет лишние символы для корректной вставки в Finder
    @IBAction func copyRealmFileAdress(_ sender: Any) {
        
        var realmFileAdress: String = "\(Realm.Configuration.defaultConfiguration.fileURL!)"
        let range = realmFileAdress.index(realmFileAdress.startIndex, offsetBy: 0)..<realmFileAdress.index(realmFileAdress.startIndex, offsetBy: 7)
        realmFileAdress.removeSubrange(range)
        
        UIPasteboard.general.string = realmFileAdress
        
        showMassage("Ссылка на файл Realm скопирована в буфер обмена!")
    }
    

}
