typealias GlobalBindFunc = (Client, Any, UInt32, UInt32) -> Void

struct Global {

	var display: Display
	//var interface: Interface
	var name: UInt32 = 1
	var version: UInt32
	var data: Any
	var bind: GlobalBindFunc
	//var link: LinkedList<>


	init(display:Display, version:UInt32, data:Any, bind: @escaping GlobalBindFunc) throws {
		
		self.display = display
		//self.name = display.id += UInt32(1)
		self.version = version
		self.data = data
		self.bind = bind
		
		
	}

}
