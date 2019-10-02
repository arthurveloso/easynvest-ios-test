//
//  Easynvest_iOSUITests.swift
//  Easynvest-iOSUITests
//
//  Created by Arthur Melo on 27/09/19.
//  Copyright © 2019 Arthur Melo. All rights reserved.
//

import XCTest

class EasynvestiOSUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    func testSimulationFlow() {
        let amountTextField = app.textFields["amount"]
        amountTextField.tap()
        amountTextField.typeText("2000")

        let dateTextField = app.textFields["date"]
        dateTextField.tap()
        dateTextField.typeText("29062023")

        let cdiRateTextField = app.textFields["rate"]
        cdiRateTextField.tap()
        cdiRateTextField.typeText("100")

        let simulateButton = app.buttons["simulate"]
        app.tap()
        simulateButton.tap()
    }
}
