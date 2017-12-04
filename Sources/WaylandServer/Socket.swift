#if os(Linux)
import Glibc
#else
import Darwin
#endif

private let UNIX_PATH_MAX = 108
private let LOCK_SUFFIX = ".lock"
private let LOCK_SUFFIXLEN = 5

public class Socket {

	var fd: Int = 0
	var fdLock: Int = 0
	var address: sockaddr_un = sockaddr_un()	
	var lockAddr: Array<CChar> = []
	//var link: LinkedList<>
	//var source: EventSource
	var displayName: String
	

}
