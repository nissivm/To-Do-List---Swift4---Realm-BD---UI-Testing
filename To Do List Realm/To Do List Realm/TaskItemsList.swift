//
//  TaskItemsList.swift
//  To Do List Realm
//
//  Created by Altran Portugal Fundão Nissi on 23/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import UIKit
import RealmSwift

class TaskItemsList: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    private let tableReuseId = "TaskItemCell"
    private var taskItems: Results<TaskItem>?
    
    var task: Task!
    
    //----------------------------------------------------------------------//
    // MARK: Initialization / Deinitialization
    //----------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableReuseId)
        
        if let realm = AppDelegate.getRealm()
        {
            let predicate = NSPredicate(format: "taskId == %@", task.taskId)
            taskItems = realm.objects(TaskItem.self).filter(predicate)
            tableView.reloadData()
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: IBActions
    //----------------------------------------------------------------------//
    
    @IBAction func addTaskItemButtonTapped(_ sender: UIButton)
    {
        let addTaskItemAlert = UIAlertController(title: "Enter item:",
                                                 message: "",
                                                 preferredStyle: .alert)
        
        addTaskItemAlert.addTextField
        {
            (textField) in
            textField.placeholder = "Item name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler:
        {
            [unowned self](alert) -> Void in
            
            let newTaskItemNameTxtField = addTaskItemAlert.textFields![0] as UITextField
            let newTaskItemName = newTaskItemNameTxtField.text
            
            let cc = newTaskItemName != nil ? newTaskItemName!.count : 0
            
            guard cc > 0 else
            {
                return
            }
            
            guard let realm = AppDelegate.getRealm() else
            {
                print("\n Could not add item task: Could not instantiate Realm \n")
                return
            }
            
            let newTaskItem = TaskItem()
                newTaskItem.taskId = self.task.taskId
                newTaskItem.name = newTaskItemName!
            
            do
            {
                try realm.write
                {
                    realm.add(newTaskItem)
                    let predicate = NSPredicate(format: "taskId == %@", self.task.taskId)
                    self.taskItems = realm.objects(TaskItem.self).filter(predicate)
                    self.tableView.reloadData()
                }
                
                print("\n New task item \(newTaskItemName!) successfully added! \n")
            }
            catch
            {
                print("\n Could not save new task item \n")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addTaskItemAlert.addAction(addAction)
        addTaskItemAlert.addAction(cancelAction)
        
        addTaskItemAlert.view.tintColor = UIColor.black
        present(addTaskItemAlert, animated: true)
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDelegate
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("\n Selected task item: \(taskItems![indexPath.row].name) \n")
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDataSource
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return taskItems != nil ? taskItems!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableReuseId)
        
        cell!.textLabel?.text = taskItems![indexPath.row].name
        
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
