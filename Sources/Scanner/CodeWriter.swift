//===----------------------------------------------------------------------===//
//
// This source file is part of the Cyllene open source project
//
// Copyright (c) 2017 Chris Daley
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information
//
//===----------------------------------------------------------------------===//

class CodeWriter {

	var context: CodeContext!
	
	var outputStream: OutputStream!

	var indent: Int = 0
	
	var bol: Bool = true
	
	

	func writeFile(context:CodeContext, fileName: String) throws {

		
		let fileManager = FileManager.default()
		var tempFileName = fileName
		let fileExists = fileManager.fileExists(atPath: fileName)
		
		if  fileExists {
			tempFileName = fileName += ".swifttmp"
		}
		
		try self.outputStream = OutputStream(path: tempFileName)
		
		let version = context.version
		
		writeString("// Generated by WaylandScanner \(version)")
		writeNewline()
		writeNewline()
		
		self.context = context
			
		self.context.accept(self)
		
		if fileExists {
			if fileManager.contentsEqual(atPath: fileName, andPath: tempFileName) {
				fileManager.removeItem(atPath: tempFileName)
			} else {
				fileManager.removeItem(atPath: fileName)
				fileManager.moveItem(atPath: tempfileName, toPath: fileName)
			}
		}		

	}

	func writeString(string: String) {
		print(string, toStream: &outputStream)
		bol = false
	}

	func writeNewline() {
		print('\n', toStream: &outputStream)
		bol = true
		
	}


	func visit_interface (interface: Interface) {
		
	}
	
	func visit_description (description: Description) {
		
	}
	
	func visit_request(request: Request) {
		
	}
	
	func visit_arg(arg: Arg) {
		
	}
	
	func visit_event(event:Event) {
		
	}
	


}

enum CodeWriterError : Error {
	
	
}