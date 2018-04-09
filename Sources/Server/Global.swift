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
		display.globals.append(self)
		
	}

}
