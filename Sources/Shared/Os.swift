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

func epollCreateCloexec() -> Int32 {

	var fd: Int32 = 0
	
	//fd = epoll_create1(EPOLL_CLOEXEC)
	
	if fd >= 0 {
		return fd
	}
	if errno != EINVAL {
		return -1
	}
	
	//fd = epoll_create(1)
	return setCloexecOrClose(fd:fd)
}


func setCloexecOrClose(fd:Int32) -> Int32 {
	
	if fd == -1 {
		return -1
	}
	
	let flags: Int32 = fcntl(fd, F_GETFD)
	
	if flags == -1 {
		close(fd)
		return -1
	}
	
	//if fnctl(fd, F_SETFD, flags | FD_CLOEXEC) == -1 {
	//	close(fd)
	//	return -1
	//}
	
	return fd

}
