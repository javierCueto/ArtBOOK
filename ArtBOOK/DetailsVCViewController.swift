//
//  DetailsVCViewController.swift
//  ArtBOOK
//
//  Created by José Javier Cueto Mejía on 08/04/20.
//  Copyright © 2020 Pozolx. All rights reserved.
//

import UIKit

class DetailsVCViewController: UIViewController {
    
    @IBOutlet weak var artImage: UIImageView!
    @IBOutlet weak var nameLable: UITextField!
    @IBOutlet weak var artistLabel: UITextField!
    @IBOutlet weak var yearLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        artImage.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        artImage.addGestureRecognizer(imageTapRecognizer)
    }
       
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    @objc func selectImage(){
        print("image tap")
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = .photoLibrary
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
    }
   


}

extension DetailsVCViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        artImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailsVCViewController: UINavigationControllerDelegate{
    
}
