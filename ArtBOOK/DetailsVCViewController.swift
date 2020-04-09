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
    }
       
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @IBAction func saveButton(_ sender: Any) {
        
    }
   


}
