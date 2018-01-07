#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Shared
import RxSwift

public class Client {

	var connection: Connection
	var display: Display
	var disposeBag = DisposeBag()
	
	var objects: [UInt32: Resource] = [:]
	
	//var ucred: ucred?

	
	//var displayResource: Resource
	//var destroySignal: PrivateSignal
	//var error: Int
	//var resourceCreatedSignal: PrivateSignal


	init (display:Display, fd:FileDescriptor) {
		
		self.display = display
		
		connection = Connection(fd: fd)

		let source = display.loop.add(fd:fd)
		
		source
			.flatMap { (e) -> Observable<[UInt32]> in		
				if e == .writable {
					self.connection.flush()
				}
				return self.connection.read()
			}
			.flatMap { msg -> Observable<Closure> in
				return self.demarshal(data: msg)
			}
			.subscribe(onNext: { closure in
				closure.dispatch()
			})
			.disposed(by:disposeBag)
		
		display.createClient.onNext(self)
	}
	
	
	private func demarshal(data: [UInt32]) ->  Observable<Closure> {
		return Observable.create { observer in
			
			let cancel = Disposables.create()

			let opcode = data[1] & 0xffff
			
			let resource = self.objects[data[0]]
			
			let object = resource!.object
			
			if opcode >= object.interface!.methodCount {
				
			}
			
			let message = object.interface!.methods[Int(opcode)]
			let closure = Closure(message: message, payload: Array(data[2...]))
			
			observer.on(.next(closure))

			return cancel
		}
	}
	
	public func flush() {
		
	}
	
	public func getDisplay() -> Display {
		return display
	}
	
	public func getCredentials() {
		
	}	

}
