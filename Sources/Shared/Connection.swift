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

import RxSwift
import Dispatch

public class Connection {

	var `in`, out: Buffer?
	var fdsIn, fdsOut: Buffer?
	var fd: FileDescriptor
	var wantFlush: Bool = false
	var queue: DispatchQueue?
	
	public init(fd: FileDescriptor) {
		
		self.fd = fd
		
		
	}
	
	
	public func read() -> Observable<UInt8> {
		
		return Observable.create { observer in

			let channel = DispatchIO(
				type: .stream,
				fileDescriptor: self.fd,
				queue: self.queue!,
				cleanupHandler: { (fd) in }
			)

			channel.setLimit(lowWater: 1)
			

			let cancel = Disposables.create {
				channel.close(flags: .stop)
			}

			channel.read(offset: 0, length: Int.max, queue: self.queue!) { done, data, code in
				
				if cancel.isDisposed {
					return
				}
				
				data!.forEach() { byte in					
					observer.on(.next(byte))
				}
			}
			
			return cancel		

		}
	}
	
	
}
