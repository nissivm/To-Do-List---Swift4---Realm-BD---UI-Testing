//
//  ToDoLists.swift
//  To Do List Realm
//
//  Created by Altran Portugal Fundão Nissi on 23/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoLists: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editDoneButton: UIButton!
    
    private let tableReuseId = "ToDoListCell"
    private var toDoLists: Results<ToDoList>?
    
    //----------------------------------------------------------------------//
    // MARK: Initialization / Deinitialization
    //----------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableReuseId)
        
        editDoneButton.isEnabled = false
        editDoneButton.alpha = 0.2
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if let realm = AppDelegate.getRealm()
        {
            toDoLists = realm.objects(ToDoList.self)
            tableView.reloadData()
        }
        
        if let toDoLi = toDoLists
        {
            if toDoLi.count > 0
            {
                editDoneButton.isEnabled = true
                editDoneButton.alpha = 1
            }
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: IBActions
    //----------------------------------------------------------------------//
    
    @IBAction func addToDoListButtonTapped(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Enter to do list name:",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField
        {
            (textField) in
            textField.placeholder = "To Do List name"
            textField.autocapitalizationType = .sentences
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler:
        {
            [unowned self](alert_) -> Void in
            
            let textField = alert.textFields![0] as UITextField
            
            guard textField.text != "" else
            {
                return
            }
            
            guard let realm = AppDelegate.getRealm() else
            {
                print("\n Could not add to do list: Could not instantiate Realm \n")
                return
            }
            
            let newToDoList = ToDoList()
                newToDoList.listId = NSUUID().uuidString
                newToDoList.name = textField.text!
            
            var success = false
            
            do
            {
                try realm.write
                {
                    realm.add(newToDoList)
                    self.toDoLists = realm.objects(ToDoList.self)
                    self.tableView.reloadData()
                    
                    self.editDoneButton.isEnabled = true
                    self.editDoneButton.alpha = 1
                    
                    success = true
                    
                    print("\n New to do list \(textField.text!) successfully added! \n")
                }
            }
            catch {}
            
            if !success
            {
                
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        alert.view.tintColor = UIColor.black
        present(alert, animated: true)
    }
    
    @IBAction func editDoneButtonTapped(_ sender: UIButton)
    {
        if tableView.isEditing
        {
            tableView.isEditing = false
            editDoneButton.setTitle("Edit", for: UIControlState())
        }
        else
        {
            tableView.isEditing = true
            editDoneButton.setTitle("Done", for: UIControlState())
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDelegate
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("\n Selected to do list: \(toDoLists![indexPath.row].name) \n")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let toDoListItems = ToDoListItems(nibName: "ToDoListItems", bundle: nil)
            toDoListItems.toDoList = toDoLists![indexPath.row]
        
        navigationController!.pushViewController(toDoListItems, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle != .delete
        {
            return
        }
        
        print("\n Delete this to do list \n")
        
        guard let realm = AppDelegate.getRealm() else
        {
            print("\n Could not delete to do list: Could not instantiate Realm \n")
            
            self.tableView.isEditing = false
            editDoneButton.setTitle("Edit", for: UIControlState())
            
            return
        }
        
        let toDoListToDelete = toDoLists![indexPath.row]
        
        do
        {
            try realm.write
            {
                realm.delete(toDoListToDelete)
                toDoLists = realm.objects(ToDoList.self)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        catch {}
        
        tableView.isEditing = false
        editDoneButton.setTitle("Edit", for: UIControlState())
        
        if toDoLists!.count == 0
        {
            editDoneButton.isEnabled = false
            editDoneButton.alpha = 0.2
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDataSource
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return toDoLists != nil ? toDoLists!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableReuseId)
        
        cell!.textLabel?.text = toDoLists![indexPath.row].name
        
        return cell!
    }
    
    //----------------------------------------------------------------------//
    // MARK: Memory Warning
    //----------------------------------------------------------------------//

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
