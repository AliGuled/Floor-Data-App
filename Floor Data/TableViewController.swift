//
//  ViewController.swift
//  Floor Data
//
//  Created by Guled Ali on 4/16/19.
//  Copyright © 2019 Guled Ali. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var floors: [Floor] = []
    var managedContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
      
    }
    @IBAction func addFloor(_ sender: UIBarButtonItem) {
        addFloor()
        refreshTable()
    }
    
    @IBAction func increasePrice(_ sender: UIBarButtonItem) {
        increasePriceForSelectedFloor()
        refreshTable()
    }
    
    @IBAction func deleteFloor(_ sender: UIBarButtonItem) {
        deleteSlectedFloor()
        refreshTable()
    }
    
    func addFloor() {
        let floor = Floor(context: managedContext!)
        
        let price = Float((20...30).randomElement()!)
        let type = ["Carpet", "Wood", "Tile"].randomElement()
        
        floor.type = type
        floor.price = price
        do {
            try managedContext!.save()
        } catch {
            print("Error saving, \(error)")
        }
    }
    
    func loadFloors() {
        let fetchRequest = NSFetchRequest<Floor>(entityName: "Floor")
        
        do {
            floors = try (managedContext!.fetch(fetchRequest))
        } catch {
            print("Error fetching data because")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorCell")!
        
        let floor = floors[indexPath.row]
        
        cell.textLabel?.text = floor.type
        cell.detailTextLabel?.text = "$\(floor.price) per square foot"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floors.count
    }
    
    func refreshTable() {
        loadFloors()
        tableView.reloadData()
    }
    
    func deleteSlectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else {return}
        
        let row = selectedPath.row
        
        let floor = floors[row]
        
        managedContext?.delete(floor)
        
        do {
            try managedContext?.save()
        }catch {
            print("Error deleting \(error)")
        }
    }
    
    func increasePriceForSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else {return}
        
        let row = selectedPath.row
        
        let floor = floors[row]
        
        floor.price += 1
        
        do {
            try managedContext?.save()
        }catch {
            print("Error updating price because \(error)")
        }
        
    }
}

