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

public class Proxy {

	var object: Object
	var display: Display
	var queue: EventQueue
	var flags: ProxyFlag
	var refCount: Int
	var userData: Any?
	var dispatcher: DispatcherFunc
	var version: UInt32



	public func create(interface:Interface, version:UInt32) -> Proxy {
		
		display.mutex.unbalancedLock()
		

		
		display.mutex.unbalancedUnlock()
		
	}

}
