import XCTest
@testable import ClientTests
@testable import ServerTests

XCTMain([
    testCase(ClientTests.allTests),
    testCase(ServerTests.allTests),
])
