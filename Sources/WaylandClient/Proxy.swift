public class Proxy {

	var object: Object
	var display: Display
	var queue: EventQueue
	var flags: ProxyFlag
	var refCount: Int
	var userData: Any?
	var dispatcher: DispatcherFunc
	var version: UInt32



	public create(interface:Interface, version:UInt32) -> Proxy {
		
		display.mutex.unbalancedLock()
		

		
		display.mutex.unbalancedUnlock()
		
	}

}
