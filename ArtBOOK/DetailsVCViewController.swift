//
//  DetailsVCViewController.swift
//  ArtBOOK
//
//  Created by José Javier Cueto Mejía on 08/04/20.
//  Copyright © 2020 Pozolx. All rights reserved.
//

import UIKit
import CoreData

class DetailsVCViewController: UIViewController {
    
    @IBOutlet weak var artImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
       
        let newPainting = NSEntityDescription.insertNewObject(forEntityName : "Paintings", into: context)
        
        if let year = Int(yearText.text!) {
             newPainting.setValue(year, forKey: "year")
        }
        newPainting.setValue(nameText.text, forKey: "name")
        newPainting.setValue(artistText.text, forKey: "artist")
        newPainting.setValue(UUID(), forKey: "id")
        
        let data = artImage.image!.jpegData(compressionQuality: 0.5)
        
        newPainting.setValue(data, forKey: "image")
        
        
        do {
            try  context.save()
            print("data saved in DB")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
        
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
