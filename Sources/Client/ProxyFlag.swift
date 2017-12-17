//===----------------------------------------------------------------------===//
// ProxyFlag.swift
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

struct ProxyFlag : OptionSet {
	
    let rawValue: Int

    static let idDeleted = ProxyFlag(rawValue: 1 << 0)
    static let destroyed = ProxyFlag(rawValue: 1 << 1)
    static let wrapper	 = ProxyFlag(rawValue: 1 << 2)
}
