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
@testable import WaylandClient

class ClientTests: XCTestCase {

    func testDestroyListener() {

		var rawDescriptors: [Int32] = [0, 0]

		XCTAssertEqual(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, &rawDescriptors), 0)

		var display = Display()

		XCTAssertNotNil(display)
		
		var client = Client(display, rawDescriptors[0])
		
		XCTAssertNotNil(client)
		

    }


    static var allTests = [
        ("testDestroyListener", testDestroyListener),
    ]
}
