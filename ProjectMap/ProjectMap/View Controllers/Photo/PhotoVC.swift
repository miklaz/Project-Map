//
//  photoVC.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 21.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoVC: UIViewController {
    
    // MARK: - Const, Var & Outlets
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var installAvatarButton: UIButton!
    @IBOutlet var savePhotoButton: UIButton!
    
    var photo: UIImage?
    
    
    // MARK: - VС Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installAvatarButton.alpha = 0
        savePhotoButton.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Methods
    // Process photo saving result
    @objc func image(_ image: UIImage,
        didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
        }
    }
    
    func photoSelect(type: UIImagePickerController.SourceType) {
        // Проверка, поддерживает ли устройство камеру
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return showAlert("У вашего устройства отсутсвует камера!")} 
        // Создаём контроллер и настраиваем его
        let imagePickerController = UIImagePickerController()
        // Источник изображений: камера || фото библиотека
        imagePickerController.sourceType = type
        // Изображение можно редактировать
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
                
        // Показываем контроллер
        present(imagePickerController, animated: true)
    }
    
    func showAlert(_ title: String) {   //  Выводит сообщения в виде alert
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - IBActions
    @IBAction func takePicture(_ sender: UIButton) {    //  Выбор откуда взять фото
        let alert = UIAlertController(title: "Выберите действие", message: "Для установки аватара", preferredStyle: .actionSheet)
        
        let photo =  UIAlertAction(title: "Выбрать из галереи", style: .default) { (_) in
            self.photoSelect(type: .photoLibrary)
        }
        let camera =  UIAlertAction(title: "Сделать фото", style: .default) { (_) in
            self.photoSelect(type: .camera)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func installAvatar(_ sender: Any) {   //  Установка автара пользователя
        Singlton.shared.photo = photo
        showAlert("Аватар установлен!")
    }
    
    @IBAction func save(_ sender: AnyObject) {      //  Cохранение аватара пользователя в Photo Library
        UIImageWriteToSavedPhotosAlbum(photo!, self,
                #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        showAlert("Фото сохранено!")
    }
    
}

