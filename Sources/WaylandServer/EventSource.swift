import OS

public struct EventSource {

	//var interface: EventSourceProtocol
	var loop: EventLoop
	//var link: LinkedList<>
	var data: Any
	var fd: SignalFileDescriptor

}
