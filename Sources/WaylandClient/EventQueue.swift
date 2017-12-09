public class EventQueue {
	var eventList = LinkedList<Closure>()
	var display: Display
	
	public init(display:Display) {
		
		self.display = display
		
	}
	
	deinit() {
		
		display.mutex.unbalancedLock()
		
		release()
		
		display.mutex.unbalancedUnlock()

		
	}
	
	func release() {
		
		
		
		
	}
	
}
