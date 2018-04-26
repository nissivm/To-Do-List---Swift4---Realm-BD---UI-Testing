//
//  TasksList.swift
//  To Do List Realm
//
//  Created by Altran Portugal Fundão Nissi on 23/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import UIKit
import RealmSwift

class TasksList: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    private let tableReuseId = "TaskCell"
    private var tasks: Results<Task>?
    
    //----------------------------------------------------------------------//
    // MARK: Initialization / Deinitialization
    //----------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableReuseId)
        
        if let realm = AppDelegate.getRealm()
        {
            tasks = realm.objects(Task.self)
            tableView.reloadData()
        }
    }
    
    //----------------------------------------------------------------------//
    // MARK: IBActions
    //----------------------------------------------------------------------//
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton)
    {
        let addTaskAlert = UIAlertController(title: "Enter task name:",
                                      message: "",
                                      preferredStyle: .alert)
        
        addTaskAlert.addTextField
        {
            (textField) in
            textField.placeholder = "Task name"
        }
        
        let newTaskNameTxtField = addTaskAlert.textFields![0] as UITextField
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler:
        {
            [unowned self](alert) -> Void in
            
            let newTaskName = newTaskNameTxtField.text
            let cc = newTaskName != nil ? newTaskName!.count : 0
            
            guard cc > 0 else
            {
                return
            }
            
            guard let realm = AppDelegate.getRealm() else
            {
                print("\n Could not add task: Could not instantiate Realm \n")
                return
            }
            
            let newTask = Task()
                newTask.taskId = NSUUID().uuidString
                newTask.name = newTaskName!
            
            do
            {
                try realm.write
                {
                    realm.add(newTask)
                    self.tasks = realm.objects(Task.self)
                    self.tableView.reloadData()
                }
                
                print("\n New task \(newTaskName!) successfully added! \n")
            }
            catch 
            {
                print("\n Could not save new task \n")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addTaskAlert.addAction(addAction)
        addTaskAlert.addAction(cancelAction)
        
        addTaskAlert.view.tintColor = UIColor.black
        
        present(addTaskAlert, animated: true, completion: {
            newTaskNameTxtField.becomeFirstResponder()
        })
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDelegate
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("\n Selected task: \(tasks![indexPath.row].name) \n")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let taskItemsList = TaskItemsList(nibName: "TaskItemsList", bundle: nil)
            taskItemsList.task = tasks![indexPath.row]
        
        navigationController!.pushViewController(taskItemsList, animated: true)
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDataSource
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tasks != nil ? tasks!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableReuseId)
        
        cell!.textLabel?.text = tasks![indexPath.row].name
        
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
