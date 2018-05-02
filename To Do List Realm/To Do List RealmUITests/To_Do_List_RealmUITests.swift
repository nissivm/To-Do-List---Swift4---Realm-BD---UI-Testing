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
    
//    func testRecordTest()
//    {
//        let app = XCUIApplication()
//        let enterToDoListNameAlert = app.alerts["Enter to do list name:"]
//        let toDoListNameTextField = enterToDoListNameAlert.collectionViews.textFields["To Do List name"]
//        toDoListNameTextField.typeText("No")
//        toDoListNameTextField.typeText("Nov")
//        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        toDoListNameTextField.typeText("a")
//        
//        let espaOKey = app/*@START_MENU_TOKEN@*/.keys["espaço"]/*[[".keyboards.keys[\"espaço\"]",".keys[\"espaço\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        espaOKey.tap()
//        toDoListNameTextField.typeText(" ")
//        
//        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        tKey.tap()
//        toDoListNameTextField.typeText("t")
//        
//        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        oKey.tap()
//        toDoListNameTextField.typeText("o")
//        espaOKey.tap()
//        toDoListNameTextField.typeText(" ")
//        app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        toDoListNameTextField.typeText("d")
//        oKey.tap()
//        toDoListNameTextField.typeText("o")
//        espaOKey.tap()
//        toDoListNameTextField.typeText(" ")
//        app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        toDoListNameTextField.typeText("l")
//        app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        toDoListNameTextField.typeText("i")
//        app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        toDoListNameTextField.typeText("s")
//        tKey.tap()
//        toDoListNameTextField.typeText("t")
//        enterToDoListNameAlert.buttons["Add"].tap()
//        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Nova to do list"]/*[[".cells.staticTexts[\"Nova to do list\"]",".staticTexts[\"Nova to do list\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.navigationBars["To_Do_List_Realm.ToDoListItems"].buttons["Back"].tap()
//        
//    }
    
//    func testRecordTest()
//    {
//        
//        let app = app2
//        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Leroy Merlin"]/*[[".cells.staticTexts[\"Leroy Merlin\"]",".staticTexts[\"Leroy Merlin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.textFields["ToDoListNameTextField"].tap()
//        
//        let app2 = app
//        app2/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".textFields[\"ToDoListNameTextField\"].buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app2/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"Concluído\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.typeText("\n")
//        
//    }
    
    //----------------------------------------------------------------------//
    // MARK: Creates a new To Do List
    //----------------------------------------------------------------------//
    
    func testCreateNewToDoList()
    {
        app.launch()
        
        let addToDoListButton = app.buttons["AddToDoListButton"]
        
        guard addToDoListButton.waitForExistence(timeout: 4) else
        {
            XCTFail()
            return
        }
        
        addToDoListButton.tap()
        
        newToDoListName = "Test_\(UUID().uuidString)"
        
        let alert = app.alerts["Enter to do list name:"]
        let textField = alert.collectionViews.textFields["To Do List name"]
            textField.typeText(newToDoListName)
        
        alert.buttons["Add"].tap()
        
        XCTAssertTrue(app.tables.cells.staticTexts[newToDoListName].exists)
    }
    
    //----------------------------------------------------------------------//
    // MARK: Creates 3 new To Do List items
    //----------------------------------------------------------------------//
    
    func testCreateNewToDoListItems()
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
    // MARK: Edits new To Do List name
    //----------------------------------------------------------------------//
    
    func testEditNewToDoListName()
    {
        let previousName = app.textFields["ToDoListNameTextField"].value as! String
        let newName = "\(previousName)_Updated"
        app.textFields["ToDoListNameTextField"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".textFields[\"ToDoListNameTextField\"].buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["ToDoListNameTextField"].typeText(newName)
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"Concluído\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.navigationBars["To_Do_List_Realm.ToDoListItems"].buttons["Back"].tap()
        
        guard app.buttons["AddToDoListButton"].waitForExistence(timeout: 4) else
        {
            XCTFail()
            return
        }
        
        XCTAssertTrue(app.tables.cells.staticTexts[newName].exists)
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
