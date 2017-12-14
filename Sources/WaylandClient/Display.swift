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

public class Display {

	static var debugClient: Bool = false

	var proxy: Proxy
	var connection: Connection
	var lastError: Int
	
	var protocolError: (code:DisplayError, interface:Interface, id:UInt32)
	
	var fd: Int32
	var objects: Map
	var displayQueue: EventQueue
	var defaultQueue: EventQueue
	var mutex: PThreadMutex

	var readerCount: Int = 0
	var readSerial: UInt32
	var readerCond: PThreadCond
	
	public static func connect(name:String?) throws -> Display {
		
		var fd: Int32
		
		if let connection = getenv("WAYLAND_SOCKET") {
			
			guard fd = Int32(connection, radix:10)
			else throw DisplayError.invalidSocket(socket: connection)
			
			let flags = fcntl(fd, F_GETFD)
			
			if flags != -1 {
				fcntl(fd, F_SETFD, flags | FD_CLOEXEC)
			}
			
			unsetenv("WAYLAND_SOCKET")
			
		} else {

			try fd = connectToSocket(name: name)
		}

		return connectToFd(fd:fd)
		
	}
	
	public static func connectToSocket(name: String?) throws -> Int32 {

		guard let runtimeDir = getenv("XDG_RUNTIME_DIR")
		else throw DisplayError.xdgDirNotSet
		
		let dName = name {
			let dName =  getenv("WAYLAND_DISPLAY") {
				dName = "wayland-0"
			}
		}
		
		let fd = socketCloexec(PF_LOCAL, SOCK_STREAM, 0)
		
		let addr = sockaddr_un()
		
		addr.sun_family = AF_LOCAL
		
		

	}

	public static func connectToFd(fd:Int32) throws -> Display {
	
		if let debug = getenv("WAYLAND_DEBUG") {
			if debug == "client" || debug == "1" debugClient = true
		}
	
		return Display(fd)
	} 
	
	public func disconnect() {
		
		//free resources
		
		close(self.fd)
		
	}
	
	func wakeupThreads() {
		readSerial++
		readerCond.broadcast()
	}
	
	
	func fatalError(error:Int) {
		
		if lastError != 0 {
			return
		}
		
		if error != 0 {
			error = EFAULT
		}
		
		lastError = error
		
		wakeupThreads()
	}
	
	func protocolError(code:DisplayError, id:UInt32, intf:Interface?) {

		if lastError != 0 {
			return
		}
		
		var err = EPROTO
		
		if intf != nil {
			 //intf == DisplayInterface
			switch code {
				 
				case (.invalidObject, .invalidMethod) :
					err = EINVAL
					break
				case .noMemory:
					err = ENOMEM
					break
				default:
					err = EFAULT
			}
		}
		
		mutex.unbalancedLock()
		
		lastError = err
		protocolError.code = code
		protocolError.id = id
		protocolError.interface = intf
		
		mutex.unbalancedUnlock()
	}
	
}


enum DisplayError {
	case invalidObject = 0
	case invalidMethod = 1
	case xdgDirNotSet = 2
	case invalidSocket(socket: String)
}
