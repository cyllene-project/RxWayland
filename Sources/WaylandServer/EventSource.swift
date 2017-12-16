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
import OS

public class EventSource {

	//var interface: EventSourceProtocol
	var loop: EventLoop?
	//var link: LinkedList<>
	var data: Any?
	var fd: SignalFileDescriptor
	
	init(fd:SignalFileDescriptor) {
		
		self.fd = fd
		
	}

}
