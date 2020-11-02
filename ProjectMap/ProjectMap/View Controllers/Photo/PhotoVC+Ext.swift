//
//  PhotoVC+Ext.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 02.11.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import AVFoundation

extension PhotoVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Если нажали на кнопку Отмена, то UIImagePickerController надо закрыть
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Мы получили медиа от контроллера
        // Изображение надо достать из словаря info
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            avatarImageView.image = image
            photo = avatarImageView.image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarImageView.image = image
            photo = avatarImageView.image
        }
        
        installAvatarButton.alpha = 1
        savePhotoButton.alpha = 1
        avatarImageView.backgroundColor = UIColor.init(named: ".default")
        
        // Закрываем UIImagePickerController
        picker.dismiss(animated: true)
    }
    
}
