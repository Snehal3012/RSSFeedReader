//
//  RSSFeedReaderUITestsLaunchTests.swift
//  RSSFeedReaderUITests
//
//  Created by Snehal Firodia on 05/12/23.
//

import XCTest

final class RSSFeedReaderUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testAppCreatingSamplesWorks() throws {
        let app = XCUIApplication()
        app.launchArguments =  ["enable-testing"]
        app.launch()
        
        app.buttons["Add Feed"].tap()

        XCTAssertEqual(app.cells.count, 4, "There should be 4 cells after adding sample data.")
    }

}
