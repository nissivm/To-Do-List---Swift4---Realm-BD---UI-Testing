//
//  ToDoList.swift
//  To Do List Realm
//
//  Created by Altran Portugal Fundão Nissi on 26/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoList: Object
{
    @objc dynamic var listId = ""
    @objc dynamic var name = ""
    let listItems = List<ToDoListItem>()
}
