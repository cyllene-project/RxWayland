#if os(Linux)
import Glibc
#else
import Darwin
#endif

public class Client {

	var connection: Connection
	var source: EventSource
	var display: Display
	var displayResource: Resource
	//var link: LinkedList<>
	var object: Map
	var destroySignal: PrivateSignal
	var ucred: ucred
	var error: Int
	var resourceCreatedSignal: PrivateSignal


}
