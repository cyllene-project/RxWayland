import OS

public class EventSource {

	//var interface: EventSourceProtocol
	var loop: EventLoop?
	//var link: LinkedList<>
	var data: Any?
	var fd: SignalFileDescriptor
	
	init(fd:SignalFileDescriptor) {
		
		self.fd = fd
		
	}

}
