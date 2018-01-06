//===----------------------------------------------------------------------===//
// Closure.swift
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

public class Closure {
	
	//var count: Int
	var message: Message
	//var opcode: UInt32
	//var senderId: UInt32
	//var args: [Argument]
	//var proxy: Proxy
	//var extra: []
	
	public init(message: Message, payload: [UInt32]) {
		
		self.message = message
		
		
	}

	/*
	public struct InvokeFlag : OptionSet {
	    let rawValue: Int

		static let client = InvokeFlag(rawValue: 1 << 0)
		static let server = InvokeFlag(rawValue: 1 << 1)
	}*/
	
}
