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
#else
import Darwin
#endif

public typealias FileDescriptor = Int32

public extension FileDescriptor {
	
	public var isValid: Bool { return self >= 0 }
	
}

public enum SocketError: Error {
	
	case nameLength(name: String)
	case connection(err: Int32)
}

public struct Socket {
	
	static let pathLength = 108
		
	public var fd: FileDescriptor
	
	public init(fd: FileDescriptor, flags: Int32 = FD_CLOEXEC) {
		
		self.fd = fd
		
		if fd.isValid {
			setFlags(flags: flags)
		}
	}
	
	
	public init(name: String) throws {
	
		if name.utf8.count > Socket.pathLength {
			throw SocketError.nameLength(name: name)
		}
	
		fd = socket(PF_LOCAL, Int32(SOCK_CLOEXEC.rawValue | SOCK_STREAM.rawValue), 0)
		
		if fd.isValid != true {
			fd = socket(PF_LOCAL, Int32(SOCK_STREAM.rawValue), 0)
			setFlags(flags: FD_CLOEXEC)
		}
		let (addrPtr, addrLen) = self.makeAddress(from: name)
		defer { addrPtr.deallocate(capacity: addrLen) }
		
		let cRes = addrPtr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
			(p:UnsafeMutablePointer<sockaddr>) -> Int32 in
		#if os(Linux)
			return Glibc.connect(fd, p, socklen_t(addrLen))
		#else
			return Darwin.connect(fd, p, socklen_t(addrLen))
		#endif
		}
		
		if cRes == -1 {	
			throw SocketError.connection(err: errno)			
		}
	}
	
	func makeAddress(from: String) -> (UnsafeMutablePointer<UInt8>, Int) {
		
		let utf8 = from.utf8
	#if os(Linux)	
		let addrLen = MemoryLayout<sockaddr_un>.size
	#else
		let addrLen = MemoryLayout<UInt8>.size + MemoryLayout<sa_family_t>.size + utf8.count + 1
	#endif	
		let addrPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: addrLen)
		var memLoc = 0
	#if os(Linux)
		let afUnixShort = UInt16(AF_LOCAL)
		addrPtr[memLoc] = UInt8(afUnixShort & 0xFF)
		memLoc += 1
		addrPtr[memLoc] = UInt8((afUnixShort >> 8) & 0xFF)
		memLoc += 1
	#else
		addrPtr[memLoc] = UInt8(addrLen)
		memLoc += 1
		addrPtr[memLoc] = UInt8(AF_UNIX)
		memLoc += 1
	#endif
		for char in utf8 {
			addrPtr[memLoc] = char
			memLoc += 1
		}
		addrPtr[memLoc] = 0
		return (addrPtr, addrLen)
	}
	
	@discardableResult public func setFlags(flags: Int32) -> Int32 {
		
		let oldFlags = fcntl(fd, F_GETFD)
		
		return fcntl(fd, F_SETFD, oldFlags | flags)
		
	}
	
	
	
}
