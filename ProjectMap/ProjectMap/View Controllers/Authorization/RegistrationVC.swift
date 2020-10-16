//
//  RegistrationVC.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 14.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import RealmSwift

class RegistrationVC: UIViewController {

    
    // MARK: - Const, Var & Outlets
    var realm: Realm?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    
    
    // MARK: - VС Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Methods
    func validateFields() -> String? {  //  Проверяет поля
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                checkPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Пожалуйста, заполните все поля."
        }
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != checkPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                return "Пароли не совпадают."
        }
            
        return nil
    }

    func showMassage(_ massage: String) {   //  Выводит сообщения об ошибках
        let alert = UIAlertController(title: massage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - IBActions
    @IBAction func signUpTapped(_ sender: Any) {    //  Регистрация
        let error = validateFields()
        
        if error != nil {
            showMassage(error!) //  Сообщение при не корректно заполненых полях
        } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            do {    //  Запись пользователя
                let realm = try Realm()
                print(Realm.Configuration.defaultConfiguration.fileURL!)
                realm.beginWrite()
                
                let user = User()
                user.login = email
                user.password = password
                realm.add(user)

                try realm.commitWrite()
            } catch {
                self.showMassage("\(error)")
            }
        }
        let alert = UIAlertController(title: "Вы зарегистрированиы!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
}
