public class Display {

	var proxy: Proxy
	var connection: Connection
	var lastError: Int
	
	var protocolError: (code:DisplayError, interface:Interface, id:UInt32)
	
	var fd: Int32
	var objects: Map
	var displayQueue: EventQueue
	var defaultQueue: EventQueue
	var mutex: PThreadMutex

	var readerCount: Int
	var readSerial: UInt32
	var readerCond: PThreadCond
	
	
	func wakeupThreads() {
		
		readSerial++
		
		//pthread_cond_broadcast(readerCond);

	}
	
	
	func fatalError(error:Int) {
		
		if lastError != 0 {
			return
		}
		
		if error != 0 {
			error = EFAULT
		}
		
		lastError = error
		
		wakeupThreads()
	}
	
	func protocolError(code:DisplayError, id:UInt32, intf:Interface?) {

		if lastError != 0 {
			return
		}
		
		var err = EPROTO
		
		if intf != nil {
			 //intf == DisplayInterface
			switch code {
				 
				case (.invalidObject, .invalidMethod) :
					err = EINVAL
					break
				case .noMemory:
					err = ENOMEM
					break
				default:
					err = EFAULT
			}
		}
		
		mutex.unbalancedLock()
		
		lastError = err
		protocolError.code = code
		protocolError.id = id
		protocolError.interface = intf
		
		mutex.unbalancedUnlock()
	}
	
	
	
}


enum DisplayError {
	case invalidObject = 0
	case invalidMethod = 1
	case noMemory = 2
}
