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

struct Interface : CodeNode {

	var name: String? { get set }
	var description: Description? { get set }
	var version: UInt32 { get set }


	init (name:String?, version:UInt32) {
		self.name = name
		self.version = version
	}

}
