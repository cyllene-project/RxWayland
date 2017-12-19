//===----------------------------------------------------------------------===//
// EventPoll.swift
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


public struct EventPoll {
	
	public let fileDescriptor : FileDescriptor
	
	public init(flags: Flags = []) throws {
	#if os(Linux)
		fileDescriptor = epoll_create1(flags.rawValue)
		//throw error
		
	#else
		fileDescriptor = kqueue()
	#endif
	}

	public func add(fd: FileDescriptor, event: PollEvent) throws {
		try apply(EPOLL_CTL_ADD, fd: fd.fileDescriptor, event: event)		
	}

	public func update(fd: FileDescriptor, event: PollEvent) throws {
		try apply(EPOLL_CTL_MOD, fd: fd.fileDescriptor, event: event)
	}
	
	public func remove(fd: FileDescriptor) throws {
		try apply(EPOLL_CTL_DEL, fd: fd.fileDescriptor, event: nil)
	}

	private func apply(_ op: Int32, fd: Int32, event: PollEvent?) throws {
		let ret: Int32
		if let event = event {
			var ev = event.toCStruct()
			ret = epoll_ctl(fileDescriptor, op, fd, &ev)
		} else {
			ret = epoll_ctl(fileDescriptor, op, fd, nil)
		}
		//try CError.makeAndThrow(fromReturnCode: ret)
	}
	
	public func poll(into events: inout [PollEvent], timeout: TimeInterval? = nil, blockedSignals signals: SignalSet? = nil) throws -> Int {

		var eevs = Array<epoll_event>(repeating: epoll_event(), count: events.count)

		var ms = Int32(-1)
		if let timeout = timeout {
			ms = Int32(timeout * 1000)
		}

		let ret: Int32
		if let signals = signals {
			var sigmask = signals.toCStruct()
			ret = epoll_pwait(fileDescriptor, &eevs, Int32(eevs.count), ms, &sigmask)
		} else {
			ret = epoll_pwait(fileDescriptor, &eevs, Int32(eevs.count), ms, nil)
		}
		try CError.makeAndThrow(fromReturnCode: ret)

		for i in 0..<Int(ret) {
			events[i] = PollEvent(epollEvent: eevs[i])
		}
		return Int(ret)
	}

	public func close() throws {
		try fileDescriptor.close()
	}
	
}


extension EventPoll {

	public struct Flags: OptionSet {
	public let rawValue: Int32

	public init(rawValue: Int32) {
		self.rawValue = rawValue
	}

	public static let cloExec = Flags(rawValue: Int32(EPOLL_CLOEXEC))
	}
}
