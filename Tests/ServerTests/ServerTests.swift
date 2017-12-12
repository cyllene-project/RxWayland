import XCTest
@testable import WaylandServer

class ServerTests: XCTestCase {

    func testExample() {

        XCTAssertEqual(Wayland().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
