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

import Shared
import Foundation

typealias GlobalFilterFunc = (Client, Global, Any?) -> Bool

public class Display {

	var loop: EventLoop
	//var run: Int
	
	var id: UInt32 = 1
	var serial: UInt32 = 0
	
	//var registryResourceList: LinkedList<>
	var globalList = LinkedList<Global>()
	var socketList = LinkedList<Socket> ()
	var clientList = LinkedList<Client> ()
	var protocolLoggers = LinkedList<ProtocolLogger> ()
	
	//var destroySignal: PrivateSignal
	//var createClientSignal: PrivateSignal

	//var additionalShmFormats: Array
	
	var globalFilter: GlobalFilterFunc?
	var globalFilterData: Any?

	var debugServer: Bool = false

	init () throws {
	
		if let value = ProcessInfo.processInfo.environment["WAYLAND_DEBUG"] {
			if value == "server" || value == "1" {
				debugServer = true
			}
		}

		try self.loop = EventLoop()
		
	}
	
	

}
