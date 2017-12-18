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

#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Shared

private let UNIX_PATH_MAX = 108
private let LOCK_SUFFIX = ".lock"
private let LOCK_SUFFIXLEN = 5

class ServerSocket : NamedSocket {

	public var displayName: String {
		return String(self.name.suffix(nameLength))
	}
	
	var nameLength: Int
	var lockAddr: String?
	var fdLock: FileDescriptor = -1
	//var source: EventSource
	

	init(path: String, name: String) throws {
		nameLength = name.count
		try super.init(name: path + name, flags: Int32(SOCK_CLOEXEC.rawValue))
		lockAddr = self.name + LOCK_SUFFIX
		try lock()
		
	}

	func lock() throws {
		
		fdLock = open(lockAddr!, O_CREAT | O_CLOEXEC, (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP))
		
		if fdLock < 0 {
			lockAddr = nil
			//addr.sun_path = 0;
			throw ServerSocketError.lockFile(message: "unable to open lockfile \(lockAddr!) check permissions")
		}
		
		if flock(self.fdLock, LOCK_EX | LOCK_NB) < 0 {
			try (fdLock as FileDescriptor).close()
			throw ServerSocketError.lockFile(message: "unable to lock lockfile \(lockAddr!), maybe another compositor is running")
		}
		
		var st = stat()
		
		if stat(name, &st) < 0 {
			if errno != ENOENT {
				try (fdLock as FileDescriptor).close()
				throw ServerSocketError.lockFile(message: "did not manage to stat file \(lockAddr!)")
			}
		} else if (st.st_mode & S_IWUSR) == 1 || (st.st_mode & S_IWGRP) == 1 {
			unlink(name)
		}
	}

}

public enum ServerSocketError : Error {
	case lockFile(message: String)
}
