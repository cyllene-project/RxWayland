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

public struct EventType : OptionSet {

	public init(rawValue: Int) {
		self.rawValue = rawValue
	}

    public let rawValue: Int

	static let readable = EventType(rawValue: 0x01)
	static let writable = EventType(rawValue: 0x02)
	static let hangup = EventType(rawValue: 0x04)
	static let error = EventType(rawValue: 0x08)
	
}
