//===----------------------------------------------------------------------===//
// Socket.swift
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
private let sock_stream = Int32(SOCK_STREAM.rawValue)
#else
import Darwin
private let sock_stream = SOCK_STREAM
#endif

private let socketConnect = connect
private let socketBind = bind
private let socketListen = listen
private let fileClose = close

public typealias FileDescriptor = Int32

public extension FileDescriptor {
	
	public var isValid: Bool { return self >= 0 }
	
	public func getFlags() -> Int32 {
		return fcntl(self, F_GETFD)
	}

	@discardableResult public func setFlags(_ flags: Int32) -> Int32 {		
		return fcntl(self, F_SETFD, flags)
	}
	
	public mutating func close() throws {
		if fileClose(self) != 0 {
			throw SocketError.connection(err: String(cString: strerror(errno)))
		}
		self = -1
	}
	
	public func duplicate(minfd:Int32 = 0) throws -> FileDescriptor {
		
		var newFd = fcntl(self, F_DUPFD_CLOEXEC, minfd)
		
		if newFd.isValid {
			return newFd
		}
		
		if errno != EINVAL {
			return -1
		}
		
		newFd = fcntl(self, F_DUPFD, minfd)
		
		if newFd.setFlags(FD_CLOEXEC) < 0 {
			try newFd.close()
			return -1
		}
		
		return newFd
	}
}

public enum SocketError: Error {
	
	case nameLength(name: String)
	case connection(err: String)
	case bind(err: String)
	case listen(err: String)
	case invalidFileDescriptor
}

open class Socket {
	
	public var fd: FileDescriptor = -1

	public var isValid: Bool { return fd.isValid }
	
	public init() { }
	
	public init(flags: Int32) throws {
		self.fd = socket(AF_UNIX, sock_stream | flags, 0)
		if fd.isValid != true {
			throw SocketError.invalidFileDescriptor
		}
	}

	public init(fd: FileDescriptor) throws {
		self.fd = fd
	}

	public func close() throws {
		try self.fd.close()
	}

}

open class NamedSocket : Socket {
	
	private var address: sockaddr_un
	
	private var addressLength: Int
	
	public var name: String {
		return withUnsafePointer(to: &address.sun_path) {
			$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: address.sun_path)) {
				String(cString: $0)
			}
		}
	}
	
	public init(name: String, flags: Int32) throws {
		address = sockaddr_un()
		addressLength = name.withCString { Int(strlen($0)) }
		super.init()
		fd = socket(PF_LOCAL, sock_stream | flags, 0)
		if fd.isValid != true {
			throw SocketError.invalidFileDescriptor
		}

		try initAddress(name: name)
	}

	func initAddress(name: String) throws {
		address.sun_family = sa_family_t(AF_UNIX)
				
		guard addressLength < MemoryLayout.size(ofValue: address.sun_path)
		else { throw SocketError.nameLength(name: name) }

		_ = withUnsafeMutablePointer(to: &address.sun_path.0) { ptr in
			name.withCString {
				strncpy(ptr, $0, addressLength)
			}
		}
		
	}
	
	public func bind() throws {
		try withUnsafePointer(to: &address) {
			try $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				guard socketBind(fd, $0, socklen_t(addressLength)) != -1
				else { throw SocketError.bind(err: String(cString: strerror(errno))) }
			}
		}
		
	} 
	
	public func connect() throws {
		try withUnsafePointer(to: &address) {
			try $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				guard socketConnect(fd, $0, socklen_t(addressLength)) != -1
				else { throw SocketError.connection(err: String(cString: strerror(errno))) }
			}
		}
	}
	
	public func listen(backlog: Int32) throws {
		guard socketListen(fd, backlog) < 0
		else { throw SocketError.listen(err: String(cString: strerror(errno))) }
	}

	
}
