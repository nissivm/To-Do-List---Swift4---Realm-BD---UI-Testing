//
//  ToDoListItems.swift
//  To Do List Realm
//
//  Created by Altran Portugal Fundão Nissi on 23/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListItems: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toDoListNameTextField: UITextField!
    @IBOutlet weak var editDoneButton: UIButton!
    
    private let tableReuseId = "ToDoListItemCell"
    private var toDoListItems: Results<ToDoListItem>?
    
    var toDoList: ToDoList!
    
    //----------------------------------------------------------------------//
    // MARK: Initialization / Deinitialization
    //----------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableReuseId)
        toDoListNameTextField.text = toDoList.name
        
        editDoneButton.isEnabled = false
        editDoneButton.alpha = 0.2
        
        if let realm = AppDelegate.getRealm()
        {
            let predicate = NSPredicate(format: "listId == %@", toDoList.listId)
            toDoListItems = realm.objects(ToDoListItem.self).filter(predicate)
            tableView.reloadData()
        }
        
        if let toDoListIt = toDoListItems
        {
            if toDoListIt.count > 0
            {
                editDoneButton.isEnabled = true
                editDoneButton.alpha = 1
            }
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: IBActions
    //----------------------------------------------------------------------//
    
    @IBAction func addToDoListItemButtonTapped(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Enter item:",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField
        {
            (textField) in
            textField.placeholder = "Item name"
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
                print("\n Could not add to do list item: Could not instantiate Realm \n")
                return
            }
            
            let toDoListItem = ToDoListItem()
                toDoListItem.listId = self.toDoList.listId
                toDoListItem.name = textField.text!
            
            do
            {
                try realm.write
                {
                    realm.add(toDoListItem)
                    let predicate = NSPredicate(format: "listId == %@", self.toDoList.listId)
                    self.toDoListItems = realm.objects(ToDoListItem.self).filter(predicate)
                    self.tableView.reloadData()
                    
                    self.editDoneButton.isEnabled = true
                    self.editDoneButton.alpha = 1
                    
                    print("\n New to do list item \(textField.text!) successfully added! \n")
                    
                    return
                }
            }
            catch {}
            
            print("\n Could not save new to do list item \n")
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
        print("\n Selected to do list item: \(toDoListItems![indexPath.row].name) \n")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let toDoListItem = toDoListItems![indexPath.row]
        
        let alert = UIAlertController(title: "Edit item:",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField
        {
            (textField) in
            textField.placeholder = "Item name"
            textField.text = toDoListItem.name
            textField.autocapitalizationType = .sentences
            textField.clearButtonMode = .always
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler:
        {
            [unowned self](alert_) -> Void in
            
            let textField = alert.textFields![0] as UITextField
            
            guard textField.text != "" else
            {
                return
            }
            
            guard textField.text != toDoListItem.name else
            {
                return
            }
            
            guard let realm = AppDelegate.getRealm() else
            {
                print("\n Could not edit to do list item: Could not instantiate Realm \n")
                return
            }
            
            do
            {
                try realm.write
                {
                    self.toDoListItems![indexPath.row].name = textField.text!
                    
                    let predicate = NSPredicate(format: "listId == %@", self.toDoList.listId)
                    self.toDoListItems = realm.objects(ToDoListItem.self).filter(predicate)
                    
                    self.tableView.reloadData()
                    
                    print("\n Successfully edited to do list item! \n")
                    
                    return
                }
            }
            catch {}
            
            print("\n Could not update to do list item \n")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        
        alert.view.tintColor = UIColor.black
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle != .delete
        {
            return
        }
        
        print("\n Delete this to do list item \n")
        
        guard let realm = AppDelegate.getRealm() else
        {
            print("\n Could not delete to do list item: Could not instantiate Realm \n")
            
            self.tableView.isEditing = false
            editDoneButton.setTitle("Edit", for: UIControlState())
            
            return
        }
        
        let toDoListItemToDelete = toDoListItems![indexPath.row]
        
        do
        {
            try realm.write
            {
                realm.delete(toDoListItemToDelete)
                let predicate = NSPredicate(format: "listId == %@", toDoList.listId)
                toDoListItems = realm.objects(ToDoListItem.self).filter(predicate)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        catch {}
        
        tableView.isEditing = false
        editDoneButton.setTitle("Edit", for: UIControlState())
        
        if toDoListItems!.count == 0
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
        return toDoListItems != nil ? toDoListItems!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableReuseId)
        
        cell!.textLabel?.text = toDoListItems![indexPath.row].name
        
        return cell!
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITextFieldDelegate
    //----------------------------------------------------------------------//
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("\n Finished editing text field \n")
        
        guard textField.text != "" else
        {
            textField.text = toDoList.name
            return
        }
        
        guard textField.text != toDoList.name else
        {
            return
        }
        
        guard let realm = AppDelegate.getRealm() else
        {
            print("\n Could not update to do list's name: Could not instantiate Realm \n")
            textField.text = toDoList.name
            return
        }
        
        do
        {
            try realm.write
            {
                toDoList.name = textField.text!
                return
            }
        }
        catch {}
        
        textField.text = toDoList.name
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //----------------------------------------------------------------------//
    // MARK: Memory Warning
    //----------------------------------------------------------------------//

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
