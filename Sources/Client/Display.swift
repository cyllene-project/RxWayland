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
#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Foundation
import Shared

public class Display {

	var socket: Socket	

	var mutex: PThreadMutex = PThreadMutex()
	var readerCond: PThreadCond = PThreadCond()
	var readerCount: Int = 0
	var readSerial: UInt32 = 0

	//var proxy: Proxy?
	//var connection: Connection
	//var lastError: Int32 = 0
	//var protocolError: (code:DisplayError, interface:Interface, id:UInt32)
	
	//var objects: Map
	//var displayQueue: EventQueue
	//var defaultQueue: EventQueue

	init(fd: FileDescriptor) throws {
		socket = try Socket(fd: fd)
	}
	
	init(socketName: String) throws {
		socket = try NamedSocket(name:socketName, flags:FD_CLOEXEC)
		try (socket as! NamedSocket).connect()
	}
	
	public static func connect(name:String? = nil) throws -> Display {
				
		if let connection = ProcessInfo.processInfo.environment["WAYLAND_SOCKET"] {
			
			guard let fd = Int32(connection, radix:10)
			else { throw DisplayError.invalidSocket(socket: connection) }
			
			let flags = fd.getFlags()
			if flags != -1 {
				fd.setFlags(flags | FD_CLOEXEC)
			}
			
			unsetenv("WAYLAND_SOCKET")
			return try Display(fd: fd)
			
		} else {

			guard let runtimeDir = getenv("XDG_RUNTIME_DIR")
			else { throw DisplayError.xdgDirNotSet }

			let socketName = "\(runtimeDir)/" +
				(name ?? (ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] ?? "wayland-0"))

			return try Display(socketName: socketName)
		}		
	}
	

	public static func connectToFd(fd:FileDescriptor) throws -> Display {
		return try Display(fd: fd)
	} 
	
	public func disconnect() throws {
		//free resources
		try socket.close()
	}
	
	func wakeupThreads() {
		readSerial += 1
		readerCond.broadcast()
	}
	
}


enum DisplayError : Error {
	case invalidObject
	case invalidMethod
	case xdgDirNotSet
	case invalidSocket(socket: String)
}
