import Foundation

struct EchoStep {

    weak var echoService: EchoService?

    func make(queue: DispatchQueue? = nil, next: Step? = nil) -> Step {
        return { io in

            guard let message = io["message"] as? String else {
                preconditionFailure()
            }

            self.echoService?.echo(queue: queue, message: message) { result in
                guard case .success(let message) = result else {
                    return
                }

                next?(["message":message])
            }
        }
    }
}