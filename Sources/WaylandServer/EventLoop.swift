import Epoll

public struct EventLoop {

	var epollFd: Epoll
	//var checkList: LinkedList<>
	//var idleList: LinkedList<>
	//var destroyList: LinkedList<>
	
	var destroySignal: Signal

	public init () throws {
	
		self.epollFd = Epoll.init(flags:Flags.cloExec)
				
		// initialise lists
	}


	

}
