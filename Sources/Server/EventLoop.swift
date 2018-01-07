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
	private let _backgroundQueue: DispatchQueue
	private let _serialScheduler: SerialDispatchQueueScheduler
	private let _backgroundScheduler: ConcurrentDispatchQueueScheduler

	/// - returns: Current time.
	public var now : Date {
		return Date()
	}

	public init(label: String) {
		_mainQueue = DispatchQueue(label: label)
		_backgroundQueue = DispatchQueue(label: "wayland.background-queue", qos: .background)
		_serialScheduler = SerialDispatchQueueScheduler(queue: _mainQueue, internalSerialQueueName: "wayland.event-loop") 
		_backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: _mainQueue)
	}
	
	public init() {
		_mainQueue = DispatchQueue.main
		_backgroundQueue = DispatchQueue(label: "wayland.background-queue", qos: .background)
		_serialScheduler = SerialDispatchQueueScheduler(queue: _mainQueue, internalSerialQueueName: "wayland.event-loop")
		_backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: _mainQueue)
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
		
	public func add(fd: FileDescriptor) -> Observable<EventType> {

		return Observable.create { observer in
		
			let readSource = DispatchSource.makeReadSource(fileDescriptor: fd, queue: self._mainQueue)
			let writeSource = DispatchSource.makeWriteSource(fileDescriptor: fd, queue: self._mainQueue)

			let cancel = Disposables.create {
				readSource.cancel()
				writeSource.cancel()
			}

			readSource.setEventHandler {
				if cancel.isDisposed {
					return
				}
				observer.on(.next(EventType.readable))
			}
			
			writeSource.setEventHandler {
				if cancel.isDisposed {
					return
				}
				observer.on(.next(EventType.writable))
			}
			return cancel
		}.observeOn(self)
		
	}
	
	public func add(signal: Int32) -> Observable<Int32> {
		
		return Observable.create { observer in
		
			let sig = DispatchSource.makeSignalSource(signal: signal, queue: self._mainQueue)
		
			let cancel = Disposables.create {
				sig.cancel()
			}

			sig.setEventHandler {
				if cancel.isDisposed {
					return
				}
				observer.on(.next(signal))
			}
			
			return cancel
		}.observeOn(self)
	}
	
	public func add(_ idle: @escaping () -> Void) -> Observable<Void> {
		
		return Observable.create { observer in
		
			observer.on(.next(idle()))
	
			return Disposables.create()
		}
		.subscribeOn(self._backgroundScheduler)
	}
}
