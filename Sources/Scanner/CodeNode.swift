protocol CodeNode {

	var name: String? { get set }
	var description: Description? { get set }
	var version: UInt32 { get set }
	
	func write(writer: CodeWriter)
	
	func visit(visitor: Visitor)	
	
}

extension CodeNode {
	
	func visit(visitor: Visitor) {
		
	}
	
}
