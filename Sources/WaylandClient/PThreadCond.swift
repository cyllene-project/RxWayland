//===----------------------------------------------------------------------===//
// PThreadCond.swift
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


public final class PThreadCond {

	public typealias CondPrimitive = pthread_cond_t

	public var unsafeCond = pthread_cond_t()
		
	deinit {
		pthread_cond_destroy(&unsafeCond)
	}
	
	@discardableResult public func broadcast() -> Int32 {
		return pthread_cond_broadcast(&unsafeCond)
	}
	
}

