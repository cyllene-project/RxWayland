#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Shared
import RxSwift

public class Client {

	var connection: Connection
	//var source: FileDescriptorEventSource
	var display: Display
	var disposeBag = DisposeBag()
	
	var objects: [UInt32: Resource] = [:]
	
	//var displayResource: Resource
	//var link: LinkedList<>
	//var object: Map
	//var destroySignal: PrivateSignal
	//var ucred: ucred
	//var error: Int
	//var resourceCreatedSignal: PrivateSignal


	init (display:Display, fd:FileDescriptor) {
		
		self.display = display
		
		connection = Connection(fd: fd)

		let source = display.loop.add(fd:fd)
		
		source.flatMap { (e) -> Observable<[UInt32]> in
				
			if e == .writable {
				self.connection.flush()
			}
			return self.connection.read()
		}
		.flatMap { msg -> Observable<Closure> in
			
			return Observable.create { observer in
				
				let cancel = Disposables.create {
				}

				
				let opcode = msg[1] & 0xffff
				
				let resource = self.objects[msg[0]]
				
				let object = resource!.object
				
				if opcode >= object.interface!.methodCount {
					
				}
				
				let message = object.interface!.methods[Int(opcode)]
				let payload = msg[2...]
				let closure = Closure(message: message, payload: Array(payload))
				
				observer.on(.next(closure))

				return cancel
				
			}
			
			
			
		}
		
		//.addDisposableTo(disposeBag)
		//source.dispose()
		
	}
	
	
	
	
	public func flush() {
		
	}
	
	public func getDisplay() -> Display {
		return display
	}
	
	public func getCredentials() {
		
	}

	
	
	

}
