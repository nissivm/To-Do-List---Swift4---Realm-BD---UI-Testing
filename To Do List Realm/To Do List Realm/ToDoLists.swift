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
    
    private let tableReuseId = "ToDoListCell"
    private var toDoLists: Results<ToDoList>?
    
    //----------------------------------------------------------------------//
    // MARK: Initialization / Deinitialization
    //----------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableReuseId)
        
        if let realm = AppDelegate.getRealm()
        {
            toDoLists = realm.objects(ToDoList.self)
            tableView.reloadData()
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: IBActions
    //----------------------------------------------------------------------//
    
    @IBAction func addToDoListButtonTapped(_ sender: UIButton)
    {
        let addToDoListAlert = UIAlertController(title: "Enter to do list name:",
                                                 message: "",
                                                 preferredStyle: .alert)
        
        addToDoListAlert.addTextField
        {
            (textField) in
            textField.placeholder = "To Do List name"
        }
        
        let newToDoListNameTxtField = addToDoListAlert.textFields![0] as UITextField
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler:
        {
            [unowned self](alert) -> Void in
            
            let newToDoListName = newToDoListNameTxtField.text
            let cc = newToDoListName != nil ? newToDoListName!.count : 0
            
            guard cc > 0 else
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
                newToDoList.name = newToDoListName!
            
            do
            {
                try realm.write
                {
                    realm.add(newToDoList)
                    self.toDoLists = realm.objects(ToDoList.self)
                    self.tableView.reloadData()
                }
                
                print("\n New to do list \(newToDoListName!) successfully added! \n")
            }
            catch 
            {
                print("\n Could not save new to do list \n")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addToDoListAlert.addAction(addAction)
        addToDoListAlert.addAction(cancelAction)
        
        addToDoListAlert.view.tintColor = UIColor.black
        
        present(addToDoListAlert, animated: true, completion: {
            newToDoListNameTxtField.becomeFirstResponder()
        })
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
