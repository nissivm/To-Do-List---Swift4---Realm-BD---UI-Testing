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
        
        if let realm = AppDelegate.getRealm()
        {
            let predicate = NSPredicate(format: "listId == %@", toDoList.listId)
            toDoListItems = realm.objects(ToDoListItem.self).filter(predicate)
            tableView.reloadData()
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: IBActions
    //----------------------------------------------------------------------//
    
    @IBAction func addToDoListItemButtonTapped(_ sender: UIButton)
    {
        let addToDoListItemAlert = UIAlertController(title: "Enter item:",
                                                     message: "",
                                                     preferredStyle: .alert)
        
        addToDoListItemAlert.addTextField
        {
            (textField) in
            textField.placeholder = "Item name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler:
        {
            [unowned self](alert) -> Void in
            
            let newToDoListItemNameTxtField = addToDoListItemAlert.textFields![0] as UITextField
            let newToDoListItemName = newToDoListItemNameTxtField.text
            
            let cc = newToDoListItemName != nil ? newToDoListItemName!.count : 0
            
            guard cc > 0 else
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
                toDoListItem.name = newToDoListItemName!
            
            do
            {
                try realm.write
                {
                    realm.add(toDoListItem)
                    let predicate = NSPredicate(format: "listId == %@", self.toDoList.listId)
                    self.toDoListItems = realm.objects(ToDoListItem.self).filter(predicate)
                    self.tableView.reloadData()
                }
                
                print("\n New to do list item \(newToDoListItemName!) successfully added! \n")
            }
            catch
            {
                print("\n Could not save new to do list item \n")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addToDoListItemAlert.addAction(addAction)
        addToDoListItemAlert.addAction(cancelAction)
        
        addToDoListItemAlert.view.tintColor = UIColor.black
        present(addToDoListItemAlert, animated: true)
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDelegate
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("\n Selected to do list item: \(toDoListItems![indexPath.row].name) \n")
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
