#if os(Linux)
import Glibc
#else
import Darwin
#endif

func epollCreateCloexec() -> Int {

	var fd: Int
	
	fd = epoll_create1(EPOLL_CLOEXEC)
	
	if fd >= 0 {
		return fd
	}
	if errno != EINVAL {
		return -1
	}
	
	fd = epoll_create(1)
	return setCloexecOrClose(fd)
}


func setCloexecOrClose(fd:Int) -> Int {
	
	if fd == -1 {
		return -1
	}
	
	let flags: Long = fcntl(fd, F_GETFD)
	
	if flags == -1 {
		close(fd)
		return -1
	}
	
	if fnctl(fd, F_SETFD, flags | FD_CLOEXEC) == -1 {
		close(fd)
		return -1
	}
	
	return fd

}
