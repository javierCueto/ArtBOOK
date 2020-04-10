//
//  ViewController.swift
//  ArtBOOK
//
//  Created by José Javier Cueto Mejía on 08/04/20.
//  Copyright © 2020 Pozolx. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var idArray = [UUID]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
   
    @objc func getData(){
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        
        
        do{
           let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let name = result.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                }
                
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                }
            
            }
            self.tableView.reloadData()
        }catch{
            print("error when load all data")
        }
    }
    
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }


}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell ()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    
}



