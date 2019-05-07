import XCTest
@testable import HelloWorld

final class HelloWorldTests: XCTestCase {

	func testGivenMessageAssertEcho() {
		let group = DispatchGroup() 
		group.enter()

		let queue = DispatchQueue.global(qos: .utility)
		
		let echoService = EchoService()
		let echoStep = EchoStep(echoService: echoService)

		var actual: String?
		let echo = echoStep.make(queue: queue) { io in

	            actual = io["message"] as? String

		        group.leave()
		    }

		echo(["message":"Hello World!"])

		let result = group.wait(timeout: .now() + 10)
		XCTAssertEqual("Hello World!", actual, String(describing: result))
    }

	func testGivenEncodedMessageAssertMessageDecoded() {
		let group = DispatchGroup() 
		group.enter()

		let queue = DispatchQueue.global(qos: .utility)
		
		let base64Service = Base64Service()
		let echoService = EchoService()
		let decode = DecodeStep(base64Service: base64Service).successful(queue: queue)

		var actual: String?
		let echo = EchoStep(echoService: echoService).make(queue: queue) { io in

	            actual = io["message"] as? String

		        group.leave()
		    }

		let series = decode(echo)
		series(["message":"SGVsbG8gV29ybGQh"])

		let result = group.wait(timeout: .now() + 10)
		XCTAssertEqual("Hello World!", actual, String(describing: result))
    }

    func testGivenEncodedMessageAssertMessageDecodedTwice() {
		let group = DispatchGroup() 
		group.enter()

		let queue = DispatchQueue.global(qos: .utility)

		let base64Service = Base64Service()
		let echoService = EchoService()

		let decodeFirst = DecodeStep(base64Service: base64Service).successful(queue: queue)
		let decondSecond = DecodeStep(base64Service: base64Service).successful(queue: queue)

		var actual: String?
		let echo = EchoStep(echoService: echoService).make(queue: queue) { io in

	            actual = io["message"] as? String

		        group.leave()
		    }

		let series = decodeFirst(decondSecond((echo)))
		series(["message":"U0dWc2JHOGdWMjl5YkdRaA=="])
		
		let result = group.wait(timeout: .now() + 10)
		XCTAssertEqual("Hello World!", actual, String(describing: result))
    }

    static var allTests = [
    	("testGivenMessageAssertEcho", testGivenMessageAssertEcho),
        ("testGivenEncodedMessageAssertMessageDecoded", testGivenEncodedMessageAssertMessageDecoded),
        ("testGivenEncodedMessageAssertMessageDecodedTwice", testGivenEncodedMessageAssertMessageDecodedTwice)
    ]
}
