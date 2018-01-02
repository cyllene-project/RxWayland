#if os(Linux)
import Glibc
#else
import Darwin
#endif

public class Client {

	//var connection: Connection
	//var source: EventSource
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
		
		
		//self.source = display.loop.addFd(fd:fd, type:.readable, cb: connectionData, data: self)
		
		
		
		
	}
	
	public func flush() {
		
	}
	
	public func getDisplay() -> Display {
		return display
	}
	
	public func getCredentials() {
		
	}
	
	public func getFd() -> FileDescriptor {
		
	}
	
	public func getObject(id: UInt32) -> Resource {
		
	}
	
	
	

}
