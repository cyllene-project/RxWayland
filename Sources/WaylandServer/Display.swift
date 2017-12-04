typealias GlobalFilterFunc = (Client, Global, Any?) -> Bool

public class Display {

	var loop: EventLoop
	var run: Int
	
	var id: UInt32 = 1
	var serial: UInt32 = 0
	
	//var registryResourceList: LinkedList<>
	var globalList: LinkedList<Global>
	var socketList: LinkedList<Socket>
	var clientList: LinkedList<Client>
	var protocolLoggers: LinkedList<ProtocolLogger>
	
	//var destroySignal: PrivateSignal
	//var createClientSignal: PrivateSignal

	//var additionalShmFormats: Array
	
	var globalFilter: GlobalFilterFunc?
	var globalFilterData: Any?

	init () {
	
		if let value = ProcessInfo.processInfo.environment["WAYLAND_DEBUG"] {
			
		}

		self.loop = EventLoop()
		
		self.globalList = LinkedList<Global>()
		self.socketList = LinkedList<Socket>()
		self.clientList = LinkedList<Client>()
		self.protocolLoggers = LinkedList<ProtocolLogger>()

	}
	
	

}
