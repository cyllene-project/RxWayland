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
import Shared

protocol EventSource {

	var loop: EventLoop
	var data: Any
	var fd: FileDescriptor

	func dispatch(event: PollEvent) -> Int32
	
}

class FileDescriptorSource : EventSource {
	
	var loop: EventLoop
	var data: Any
	var fd: FileDescriptor
	
	init(loop: EventLoop, data: Any, fd: FileDescriptor) {
		self.loop = loop
		self.data = data
		self.fd = fd
	}

	func dispatch(event: PollEvent) -> Int32 {
		
	}
	
	
	
}
