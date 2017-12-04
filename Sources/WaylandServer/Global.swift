typealias GlobalBindFunc = (Client, Any, UInt32, UInt32) -> Void

struct Global {

	var display: Display
	//var interface: Interface
	var name: UInt32
	var version: UInt32
	var data: Any
	var bind: GlobalBindFunc
	//var link: LinkedList<>


}
