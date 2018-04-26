//
//  TasksList.swift
//  To Do List Realm
//
//  Created by Altran Portugal Fundão Nissi on 23/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import UIKit 

class TasksList: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFirstTaskButton: UIButton!
    
    let tableReuseId = "TaskCell"
    
    //----------------------------------------------------------------------//
    // MARK: Initialization / Deinitialization
    //----------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableReuseId)
        addFirstTaskButton.layer.cornerRadius = 22.0
    }
    
    //----------------------------------------------------------------------//
    // MARK: IBActions
    //----------------------------------------------------------------------//
    
    @IBAction func addFirstTaskButtonTapped(_ sender: UIButton)
    {
        
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDelegate
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //
    }
    
    //----------------------------------------------------------------------//
    // MARK: UITableViewDataSource
    //----------------------------------------------------------------------//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableReuseId)
        
        cell!.textLabel?.text = "Task"
        
        return cell!
    }
    
    //----------------------------------------------------------------------//
    // MARK: Memory Warning
    //----------------------------------------------------------------------//

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
