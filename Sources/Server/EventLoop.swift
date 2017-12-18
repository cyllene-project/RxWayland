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

//public typealias SignalFunction = (Signal, Any) -> Int

public struct EventLoop {

	var epoll: EventPoll
	
	//var checkList: LinkedList<>
	//var idleList: LinkedList<>
	//var destroyList: LinkedList<>
	
	//var destroySignal: Signal

	public init () throws {
	
		epoll = try EventPoll(flags:.cloExec)
	}
	
	
	public func add(fd: Shared.FileDescriptor, eventType: EventType) throws -> EventSource {
		
		var source = try EventSource(fd: fd.duplicate())
		
		
		return try add(source: source, eventType: eventType)
		
	}
	
	func add(source: EventSource, eventType: EventType) throws -> EventSource {
		return source
	}
	
	

	public func addSignal(signal:Signal, cb: @escaping SignalFunction, data: Any) throws -> EventSource? {
		
		let source = EventSourceSignal(signal:signal)
		
		var mask = try SignalSet(fill:false)
		
		try mask.insert(signal:signal)
		
		let fd:Int32 = -1
		
		//source.base!.fd = try mask.fileDescriptor(replacing:fd.fileDescriptor, flags:[.cloExec, .nonBlock])
		
		try mask.block(mode:.block)
		
		source.callback = cb
		
		return try addSource(source:source.base!, mask:.readable, data:data)
	}
	

	func addSource(source:EventSource, mask:EventType, data:Any) throws -> EventSource? {
		
		if source.fd.fileDescriptor < 0 {
			return nil //throw error
		}
		
		source.loop = self
		source.data = data
		//init source.link
		
		var types: PollEvent.Types = PollEvent.Types.in
		
		if mask == .writable {
			types = PollEvent.Types.out
		}

		let ep = PollEvent(types, data: .fd(source.fd.fileDescriptor))
		
		//try self.epollFd.add(fd:source.fd, event:ep)
		
		return source
		
	}

}
