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
    
    func testRecordTest()
    {
        
    }
    
    //----------------------------------------------------------------------//
    // MARK: Test creating a new To Do List
    //----------------------------------------------------------------------//
    
    func test01_CreateNewToDoList()
    {
        app.launch()
        
        let addToDoListButton = app.buttons["AddToDoListButton"]
        
        guard addToDoListButton.waitForExistence(timeout: 4) else
        {
            XCTFail()
            return
        }
        
        addToDoListButton.tap()
        
        let newToDoListName = "ToDoList_\(UUID().uuidString)"
        
        let alert = app.alerts["Enter to do list name:"]
        let textField = alert.collectionViews.textFields["To Do List name"]
            textField.typeText(newToDoListName)
        
        alert.buttons["Add"].tap()
        
        XCTAssertTrue(app.tables.cells.staticTexts[newToDoListName].exists)
    }
    
    //----------------------------------------------------------------------//
    // MARK: Test creating a new To Do List item
    //----------------------------------------------------------------------//
    
    func test02_CreateNewToDoListItem()
    {
        let lastCellIdx = app.tables.cells.count - 1
        app.tables.cells.element(boundBy: lastCellIdx).tap()
        
        guard app.buttons["AddToDoListItemButton"].waitForExistence(timeout: 4) else
        {
            XCTFail()
            return
        }
        
        createToDoListItem()
    }
    
    private var counter = 0
    
    private func createToDoListItem()
    {
        app.buttons["AddToDoListItemButton"].tap()
        
        let newToDoListItem = "Item_\(UUID().uuidString)"
        
        let alert = app.alerts["Enter item:"]
        let textField = alert.collectionViews.textFields["Item name"]
            textField.typeText(newToDoListItem)
        
        alert.buttons["Add"].tap()
        
        counter += 1
        
        XCTAssertTrue(app.tables.cells.staticTexts[newToDoListItem].exists)
        
        if counter == 3 { counter = 0 }
        else { createToDoListItem() }
    }
    
    //----------------------------------------------------------------------//
    // MARK: Test editing To Do List Item
    //----------------------------------------------------------------------//
    
    func test03_EditToDoListItem()
    {
        let newName = "Updated_Item_\(UUID().uuidString)"
        
        app.tables.cells.element(boundBy: 0).tap()
        
        let alert = app.alerts["Edit item:"]
            alert.collectionViews/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".textFields[\"Item name\"].buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let textField = alert.collectionViews.textFields["Item name"]
            textField.typeText(newName)
        
        alert.buttons["Edit"].tap()
        
        XCTAssertTrue(app.tables.cells.staticTexts[newName].exists)
    }
    
    //----------------------------------------------------------------------//
    // MARK: Test deleting To Do List Item
    //----------------------------------------------------------------------//
    
    func test04_DeleteToDoListItem()
    {
        app.buttons["EditDoneButton_"].tap()
        
        let initialNumCells = app.tables.cells.count
        
        let lastIdx = app.tables.cells.count - 1
        app.tables.buttons.element(boundBy: lastIdx).tap()
        app.tables.buttons["Delete"].tap()
        
        sleep(3)
        
        let finalNumCells = app.tables.cells.count
        
        XCTAssertTrue(initialNumCells > finalNumCells)
    }
    
    //----------------------------------------------------------------------//
    // MARK: Test editing To Do List name
    //----------------------------------------------------------------------//
    
    func test05_EditToDoListName()
    {
        let newName = "Updated_ToDoList_\(UUID().uuidString)"
        
        app.textFields["ToDoListNameTextField"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".textFields[\"ToDoListNameTextField\"].buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["ToDoListNameTextField"].typeText(newName)
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"Concluído\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.navigationBars["To_Do_List_Realm.ToDoListItems"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
        guard app.buttons["AddToDoListButton"].waitForExistence(timeout: 4) else
        {
            XCTFail()
            return
        }
        
        XCTAssertTrue(app.tables.cells.staticTexts[newName].exists)
    }
    
    //----------------------------------------------------------------------//
    // MARK: Deletes To Do List
    //----------------------------------------------------------------------//
    
    func test06_DeleteToDoList()
    {
        
    }
}
