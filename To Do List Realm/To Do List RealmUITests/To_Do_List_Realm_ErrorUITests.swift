//
//  To_Do_List_Realm_ErrorUITests.swift
//  To Do List RealmUITests
//
//  Created by Altran Portugal Fundão Nissi on 04/05/2018.
//  Copyright © 2018 App Magic. All rights reserved.
//

import XCTest

class To_Do_List_Realm_ErrorUITests: XCTestCase
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
    
    //----------------------------------------------------------------------//
    // MARK: Test creating a new To Do List with blanc text field
    //----------------------------------------------------------------------//
    
    func testCreateNewToDoListWithBlancTextField()
    {
        app.launch()
        
        let addToDoListButton = app.buttons["AddToDoListButton"]
        
        guard addToDoListButton.waitForExistence(timeout: 4) else
        {
            XCTFail()
            return
        }
        
        addToDoListButton.tap()
        
        let initialNumCells = app.tables.cells.count
        
        let alert = app.alerts["Enter to do list name:"]
            alert.buttons["Add"].tap()
        
        let finalNumCells = app.tables.cells.count
        
        XCTAssertTrue(initialNumCells == finalNumCells)
    }
}
