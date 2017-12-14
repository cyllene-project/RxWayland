//===----------------------------------------------------------------------===//
// CodeContext.swift
// 
// This source file is part of the Cyllene open source project
// https://github.com/cyllene-project
// 
// Copyright (c) 2017 Chris Daley <chebizarro@gmail.com>
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// 
// See http://www.apache.org/licenses/LICENSE-2.0 for license information
//
//===----------------------------------------------------------------------===//

class CodeContext {
	
	var version: String
	
	var root: CodeNode
	
	func accept(visitor: CodeVisitor) {
		
		self.root.accept(visitor: visitor)
		
	}
	
	
}
