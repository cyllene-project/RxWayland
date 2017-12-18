//===----------------------------------------------------------------------===//
// TestCompositor.swift
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

#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Shared
import Server
import Client

struct TestCompositor {
	
	var fd: FileDescriptor
	
	
	
	
}


class Display {
	
	var display: Server.Display
	
	//var clients: LinkedList<>
	
	var clientsNo: UInt32 = 0
	var clientsTerminatedNo: UInt32 = 0
	
	//var waitingForResume: LinkedList<>
	var wfrNum: UInt32 = 0
	
	
	init() throws {
		
		display = try Server.Display()
		
		let socketName = getSocketName()
		
		try display.addSocket(name:socketName)
		
		//let g = Global()
		
	}
	
	
	func getSocketName() -> String {
		
		var time = timeval(tv_sec: 0, tv_usec: 0)
		gettimeofday(&time, nil)
		
		return "wayland-test-" + String(getpid()) + "-" + String(time.tv_sec) + String(time.tv_usec)
		
	}
}
