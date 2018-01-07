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
import RxSwift

typealias GlobalFilterFunc = (Client, Global, Any?) -> Bool

public class Display {

	static let sharedInstance = Display()

	var loop: EventLoop
	var id: UInt32 = 1
	var serial: UInt32 = 0
	
	let createClient: PublishSubject<Client>
	let destroy: PublishSubject<Display>
	
	var disposeBag = DisposeBag()	
	
	//var registryResourceList: LinkedList<>
	var globals = LinkedList<Global>()
	var sockets = LinkedList<Socket> ()
	var clients = LinkedList<Client> ()
	var protocolLoggers = LinkedList<ProtocolLogger> ()
	
	var additionalShmFormats: [UInt32] = []
	
	var globalFilter: GlobalFilterFunc?
	var globalFilterData: Any?

	var debugServer: Bool = false

	private init () {

		self.loop = EventLoop()
		
		createClient = PublishSubject<Client>()
		destroy = PublishSubject<Display>()
	}
	
	public class func create() -> Display {
		return sharedInstance
	}
	
	public func getSerial() -> UInt32 {
		return serial
	}
	
	public func nextSerial() -> UInt32 {
		serial += 1
		return serial
	}
	
	deinit {
		destroy.onNext(self)
	}
	
	
	public func addSocket(name: String? = nil) throws {
				
		guard let runtimeDir = getenv("XDG_RUNTIME_DIR")
		else { throw DisplayError.xdgDirNotSet }

		let socketName = name ?? (ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] ?? "wayland-0")
				
		let socket = try ServerSocket(path: "\(runtimeDir)/", name: socketName)
		
		try socket.bind()
		try socket.listen(backlog: 128)
		//socket.source = try loop.add(fd:socket.fd, eventType: .readable) //callback
		sockets.append(socket)

	}

	public func add(shmFormat: UInt32) -> Int {
		additionalShmFormats += [shmFormat]
		return additionalShmFormats.count - 1
	}
	
	public func addSocket() -> String {
		
		let MAX_DISPLAYNO = 32
		
		return ""
		
	}
	
	public func flushClients() {
		_ = clients.filter { c in
			c.connection.flush()
		}
	}

}

enum DisplayError : Error {
	case xdgDirNotSet
	case invalidSocket(socket: String)
}
