import Epoll
import OS

public typealias SignalFunction = (Signal, Any) -> Int

public struct EventLoop {

	var epollFd: Epoll
	//var checkList: LinkedList<>
	//var idleList: LinkedList<>
	//var destroyList: LinkedList<>
	
	//var destroySignal: Signal

	public init () throws {
	
		try self.epollFd = Epoll.init(flags:.cloExec)
		// initialise lists
	}

	public func addSignal(signal:Signal, cb: SignalFunction, data: Any) throws -> EventSource? {
		
		var source = EventSourceSignal(signal:signal)
		
		var mask = SignalSet(fill:false)
		
		try mask.insert(signal:signal)
		
		let fd:Int32 = -1
		
		source.base!.fd = mask.fileDescriptor(replacing:fd.fileDescriptor, flags:[.cloExec, .nonBlock])
		
		try mask.block(mode:.block)
		
		source.callback = cb
		
		addSource(source:source.base, mask:.readable, data:data)
	}
	

	func addSource(source:EventSource, mask:EventType, data:Any) throws -> EventSource? {
		
		if source.fd.fileDescriptor < 0 {
			return nil //throw error
		}
		
		source.loop = self
		source.data = data
		//init source.link
		
		
		var ep = PollEvent(data: source)
		
		if mask == .readable {
			ep.types = PollEvent.in
		}
		
		if mask == .writable {
			ep.types = PollEvent.out
		}
		
		try self.epollFd.add(source.fd, ep)
		
		return source
		
	}

}
