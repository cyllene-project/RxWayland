typealias ProtocolLoggerFunction = (Any, ProtocolLoggerType, ProtocolLoggerMessage) -> Void

struct ProtocolLogger {

	//var link: LinkedList<>
	var logFunc: ProtocolLoggerFunction
	var userData: Any

}
