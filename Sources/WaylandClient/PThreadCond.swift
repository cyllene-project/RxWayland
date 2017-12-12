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

	// Non-recursive "PTHREAD_MUTEX_NORMAL" and recursive "PTHREAD_MUTEX_RECURSIVE" mutex types.
	public enum PThreadMutexType {
		case normal
		case recursive
	}

	public var unsafeMutex = pthread_mutex_t()
	
	/// Default constructs as ".Normal" or ".Recursive" on request.
	public init(type: PThreadMutexType = .normal) {
		var attr = pthread_mutexattr_t()
		guard pthread_mutexattr_init(&attr) == 0 else {
			preconditionFailure()
		}
		switch type {
		case .normal:
			pthread_mutexattr_settype(&attr, Int32(PTHREAD_MUTEX_NORMAL))
		case .recursive:
			pthread_mutexattr_settype(&attr, Int32(PTHREAD_MUTEX_RECURSIVE))
		}
		guard pthread_mutex_init(&unsafeMutex, &attr) == 0 else {
			preconditionFailure()
		}
		pthread_mutexattr_destroy(&attr)
	}
	
	deinit {
		pthread_mutex_destroy(&unsafeMutex)
	}
	
	public func unbalancedLock() {
		pthread_mutex_lock(&unsafeMutex)
	}
	
	public func unbalancedTryLock() -> Bool {
		return pthread_mutex_trylock(&unsafeMutex) == 0
	}
	
	public func unbalancedUnlock() {
		pthread_mutex_unlock(&unsafeMutex)
	}
}

