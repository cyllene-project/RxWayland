import OS

class EventSourceSignal {

	var base: EventSource?

	var signal: Signal

	var callback: SignalFunction?

	public init(signal:Signal) {
		
		self.signal = signal
	
	}

} 
