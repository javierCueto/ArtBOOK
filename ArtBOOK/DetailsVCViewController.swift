//
//  DetailsVCViewController.swift
//  ArtBOOK
//
//  Created by José Javier Cueto Mejía on 08/04/20.
//  Copyright © 2020 Pozolx. All rights reserved.
//

import UIKit
import CoreData

class DetailsVCViewController: UIViewController,UIScrollViewDelegate {
    var keySize : CGFloat?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var artImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var saveDataButton: UIButton!
    var chosenPainting = ""
    var chosenPaintingId : UUID?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.delegate = self
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
          NotificationCenter.default.addObserver(self, selector: #selector(DetailsVCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
          NotificationCenter.default.addObserver(self, selector: #selector(DetailsVCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if chosenPainting != ""{
            saveDataButton.isHidden = true
            //Query here
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let idString = chosenPaintingId?.uuidString
            
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                            nameText.isEnabled = false
                        }
                        
                        if let year = result.value(forKey: "year") as? Int {
                            yearText.text = String(year)
                            yearText.isEnabled = false
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String {
                            artistText.text = artist
                            artistText.isEnabled = false
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            artImage.image = image
                        }
                        
                    }
                }
            }catch{
                
            }
            
            
        } else {
            saveDataButton.isEnabled = false
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(gestureRecognizer)
            
            artImage.isUserInteractionEnabled = true
            let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            artImage.addGestureRecognizer(imageTapRecognizer)
        }
        
        
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(keySize)
      self.view.frame.origin.y = 0 - (keySize ?? 0)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
            print("error al ocultar")
           return
        }
      

      // move the root view up by the distance of keyboard height
        print("se movio arriba")

      
      self.view.frame.origin.y = 0 - keyboardSize.height
        keySize = keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
        print("se oculto")
    }
    
    @objc func hideKeyboard(){
        self.view.frame.origin.y = 0
        view.endEditing(true)
        keySize = 0
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
        saveDataButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailsVCViewController: UINavigationControllerDelegate{
    
}
