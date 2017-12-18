//===----------------------------------------------------------------------===//
// ClientTests.swift
// 
// This source file is part of the Cyllene open source project
// https://github.com/cyllene-project
// 
// Copyright (c) 2017 Chris Daley <chebizarro@gmail.com>
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// 
// See http://www.apache.org/licenses/LICENSE-2.0 for license information
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import Client

class ClientTests: XCTestCase {

    func testNewClient() throws {

		let  display = try Client.Display.connect()
		
		XCTAssertNotNil(display)

		display.disconnect()

    }
    
    func testGetRegistry() {
		
		//let display = Display()
		
		//var registry = display.getRegistry()

		//display.disconnect()
		
	}


    static var allTests = [
        ("testNewClient", testNewClient),
        ("testGetRegistry", testGetRegistry),
    ]
}
