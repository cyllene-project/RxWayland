import XCTest
@testable import Server

class ServerTests: XCTestCase {

    func testDestroyListener() throws {

		var rawDescriptors: [Int32] = [0, 0]

		//XCTAssertEqual(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, &rawDescriptors), 0)

		//var display = Display()

		//XCTAssertNotNil(display)
		
		//var client = Client(display, rawDescriptors[0])
		
		//XCTAssertNotNil(client)
		

    }


    static var allTests = [
        ("testDestroyListener", testDestroyListener),
    ]
}
