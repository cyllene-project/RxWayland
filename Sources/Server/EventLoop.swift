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

import struct Foundation.TimeInterval
import struct Foundation.Date
import Dispatch
import Shared
import RxSwift

public final class EventLoop : SchedulerType {

	public typealias TimeInterval = Foundation.TimeInterval
	public typealias Time = Date

	private let _mainQueue: DispatchQueue
	private let _serialScheduler: SerialDispatchQueueScheduler

	/// - returns: Current time.
	public var now : Date {
		return Date()
	}

	public init(label: String) {
		_mainQueue = DispatchQueue(label: label)
		_serialScheduler = SerialDispatchQueueScheduler(queue: _mainQueue, internalSerialQueueName: "event-loop") 
	}
	
	public init() {
		_mainQueue = DispatchQueue.main
		_serialScheduler = SerialDispatchQueueScheduler(queue: _mainQueue, internalSerialQueueName: "event-loop") 
	}


	/**
	Schedules an action to be executed immediately.
	
	- parameter state: State passed to the action to be executed.
	- parameter action: Action to be executed.
	- returns: The disposable object used to cancel the scheduled action (best effort).
	*/
	public final func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
		return _serialScheduler.schedule(state, action: action)
	}

	/**
	Schedules an action to be executed.
	
	- parameter state: State passed to the action to be executed.
	- parameter dueTime: Relative time after which to execute the action.
	- parameter action: Action to be executed.
	- returns: The disposable object used to cancel the scheduled action (best effort).
	*/
	public func scheduleRelative<StateType>(_ state: StateType, dueTime: RxTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
		return _serialScheduler.scheduleRelative(state, dueTime: dueTime, action: action)
	}
 
	/**
	Schedules a periodic piece of work.
	
	- parameter state: State passed to the action to be executed.
	- parameter startAfter: Period after which initial work should be run.
	- parameter period: Period for running the work periodically.
	- parameter action: Action to be executed.
	- returns: The disposable object used to cancel the scheduled action (best effort).
	*/
	public func schedulePeriodic<StateType>(_ state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: @escaping (StateType) -> StateType) -> Disposable {
		return _serialScheduler.schedulePeriodic(state, startAfter: startAfter, period: period, action: action)
	}
	
	public func add(fd: FileDescriptor, eventType: [EventType]) -> EventSource {
		
		return FileDescriptorSource(queue: _mainQueue, fd: fd, events: eventType)
	}
	
		
	public func add(fd: FileDescriptor, eventType: [EventType]) -> Observable<UInt> {

		return Observable.create { observer in
		
			let readSource = DispatchSource.makeReadSource(fileDescriptor: fd)

			let cancel = Disposables.create {
				readSource.cancel()
			}

			readSource.setEventHandler {
				if cancel.isDisposed {
					return
				}
				observer.on(.next(readSource.mask))
			}
			
			return cancel		
		
		}
		
	}

	
}
