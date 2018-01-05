#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Shared

public class Client {

	var connection: Connection
	var source: EventSource
	var display: Display

	//var displayResource: Resource
	//var link: LinkedList<>
	//var object: Map
	//var destroySignal: PrivateSignal
	//var ucred: ucred
	//var error: Int
	//var resourceCreatedSignal: PrivateSignal


	init (display:Display, fd:FileDescriptor) {
		
		self.display = display
		connection = Connection(fd: fd)



		source = display.loop.add(fd:fd, eventType: [.readable])
		
		
		
		
	}
	
	public func flush() {
		
	}
	
	public func getDisplay() -> Display {
		return display
	}
	
	public func getCredentials() {
		
	}

	
	
	

}
