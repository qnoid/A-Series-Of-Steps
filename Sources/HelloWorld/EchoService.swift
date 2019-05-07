import Foundation

class EchoService  {

    typealias EchoCompletionHandler = (Result) -> Void

    func echo(queue: DispatchQueue? = nil, message: String, completionHandler: @escaping EchoService.EchoCompletionHandler) {
		let process = Process()
		process.launchPath = "/bin/echo"
		process.arguments = [message]
		process.terminationHandler = { process in
            
			let isSuccess = process.terminationStatus == 0

            (queue ?? DispatchQueue.main).async {
                if isSuccess {
                    completionHandler(.success(message: message))
                } else {
                    completionHandler(.failure)
                }
            }
        }

		process.launch()
    }
}
