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

	let fd: FileDescriptor
	let queue: DispatchQueue
	let channel: DispatchIO 
	
	public init(fd: FileDescriptor, queue: DispatchQueue = DispatchQueue.main) {
		
		self.fd = fd
		self.queue = queue
		
		channel = DispatchIO(
			type: .stream,
			fileDescriptor: self.fd,
			queue: self.queue,
			cleanupHandler: { (fd) in }
		)
		
		channel.setLimit(lowWater: 1)
	}
	
	
	public func flush() -> Bool {
		return true
	}
	

	
	public func read() -> Observable<[UInt32]> {
		
		return Observable.create { observer in

			let size = MemoryLayout<UInt32>.stride

			let cancel = Disposables.create {
				self.channel.close(flags: .stop)
			}

			self.channel.read(offset: 0, length: Int.max, queue: self.queue) { done, data, code in
				
				if data == nil || data!.count < size * 2 {
					return
				}
				
				if cancel.isDisposed {
					return
				}
				
				var count = data!.count / size
				var index = 0

				let stream = data!.withUnsafeBytes { (bytes: UnsafePointer<UInt32>) in
					Array(UnsafeBufferPointer(start: bytes, count: count))
				}

				while count > 0 {
					
					let length = Int(stream[index+1] >> 16)
					let slice = stream[index...(index + length)]
					index += length
					count -= length + 1
					observer.on(.next(Array(slice)))

				}
			}
			
			return cancel		

		}
	}
	
	
}
