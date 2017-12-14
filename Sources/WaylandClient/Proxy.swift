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

import Private
import Util

public struct Proxy {

	var object: Object
	var display: Display
	var queue: EventQueue
	var flags: ProxyFlag = .wrapper
	var refCount: Int32 = 1
	var userData: Any?
	//var dispatcher: DispatcherFunc
	var version: UInt32

	public init (interface: Interface, display: Display, queue: EventQueue, version: UInt32) {
		
		self.object = Object()
		self.object.interface = interface
		self.display = display
		self.queue = queue
		self.version = version
		
	}


	public func create(factory: Proxy, interface:Interface, version:UInt32) -> Proxy {
		
		display.mutex.unbalancedLock()
		
		let proxy = Proxy(interface: interface, display: factory.display, queue: factory.queue, version: version)
		
		display.mutex.unbalancedUnlock()
		
		return proxy
	}

}
