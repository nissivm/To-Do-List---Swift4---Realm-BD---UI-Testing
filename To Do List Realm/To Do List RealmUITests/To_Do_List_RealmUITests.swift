//
//  To_Do_List_RealmUITests.swift
//  To Do List RealmUITests
//
//  Created by Altran Portugal Fundão Nissi on 23/04/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import XCTest

class To_Do_List_RealmUITests: XCTestCase
{
    private var app: XCUIApplication!
    private var newToDoListName = ""
    
    override func setUp()
    {
        super.setUp()
        
        // In UI tests, it is usually best to stop immediately when a
        // failure occurs:
        continueAfterFailure = false
        
        // Instantiating the application:
        app = XCUIApplication()
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //----------------------------------------------------------------------//
    // MARK: Creates a new To Do List
    //----------------------------------------------------------------------//
    
    func testCreateNewToDoList()
    {
        
    }
    
    //----------------------------------------------------------------------//
    // MARK: Creates 3 new To Do List items
    //----------------------------------------------------------------------//
    
    func testCreateNewToDoListItems()
    {
        
    }
    
    //----------------------------------------------------------------------//
    // MARK: Edits new To Do List name
    //----------------------------------------------------------------------//
    
    func testEditNewToDoListName()
    {
        
    }
    
    //----------------------------------------------------------------------//
    // MARK: Edits first To Do List Item's name
    //----------------------------------------------------------------------//
    
    func testEditFirstToDoListItemName()
    {
        
    }
    
    //----------------------------------------------------------------------//
    // MARK: Deletes last To Do List Item
    //----------------------------------------------------------------------//
    
    func testDeleteLastToDoListItem()
    {
        
    }
    
    //----------------------------------------------------------------------//
    // MARK: Deletes To Do List
    //----------------------------------------------------------------------//
    
    func testDeleteToDoList()
    {
        
    }
}
