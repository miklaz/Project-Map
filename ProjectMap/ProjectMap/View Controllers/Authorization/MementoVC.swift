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
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // MARK: - VС Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
