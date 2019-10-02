//
//  Easynvest_iOSTests.swift
//  Easynvest-iOSTests
//
//  Created by Arthur Melo on 27/09/19.
//  Copyright © 2019 Arthur Melo. All rights reserved.
//

import XCTest
@testable import Easynvest_iOS

class EasynvestiOSTests: XCTestCase {
    func testDecoding() {
        var dataOut: Data?
        let mockedForm = Form(amount: "2000", date: "2020-06-30", rate: "100")
        RequestManager.shared.getMockedSimulationData(from: mockedForm) { (data) in
            dataOut = data
        }
        guard let dataO = dataOut else { return }
        XCTAssertThrowsError(try JSONDecoder().decode(Simulation.self, from: dataO)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("type", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
}
