struct Interface : CodeNode {

	var name: String? { get set }
	var description: Description? { get set }
	var version: UInt32 { get set }


	init (name:String?, version:UInt32) {
		self.name = name
		self.version = version
	}

}
