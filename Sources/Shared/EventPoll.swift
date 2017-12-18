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
	#else
		fileDescriptor = kqueue()
	#endif
	}

	public func add(fd: FileDescriptor, event: PollEvent) throws {
		
		
		
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
