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
import Dispatch

public protocol EventSource {

	func dispatch()
	
}

class FileDescriptorSource : EventSource {
	
	let _mainQueue: DispatchQueue
	var fd: FileDescriptor
	var events: [EventType]
	
	var acceptSource: DispatchSourceRead
	var sendSource: DispatchSourceWrite
	
	init(queue: DispatchQueue, fd: FileDescriptor, events: [EventType]) {
		_mainQueue = queue
		self.fd = fd
		self.events = events
		
		if events.contains(.readable) {
			acceptSource = DispatchSource.makeReadSource(fileDescriptor: fd, queue: queue)
		}
		
		if events.contains(.writable) {
			sendSource = DispatchSource.makeWriteSource(fileDescriptor: fd, queue: queue)
		}
		
	}

	public func dispatch() {
		
	}

}
