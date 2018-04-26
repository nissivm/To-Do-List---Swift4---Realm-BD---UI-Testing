//
//  TaskList.swift
//  To Do List Realm
//
//  Created by Altran Portugal Fundão Nissi on 26/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object
{
    @objc dynamic var name = ""
    @objc dynamic var taskItems: [TaskItem] = []
}
