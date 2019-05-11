import Foundation

struct DecodeStep {

    weak var base64Service: Base64Service?

    func make(queue: DispatchQueue? = nil, next: Step? = nil) -> Step {
        return { io in

            guard let encoded = io["message"] as? String else {
                preconditionFailure()
            }

            self.base64Service?.decode(queue: queue, encoded: encoded) { result in 
    
            guard case .success(let message) = result else {
                return
            }

            next?(["message": message])
            }
        }
    }

    func successful(queue: DispatchQueue? = nil) -> SuccessfulStep {
        return SuccessfulStep { next in 
            return self.make(queue: queue, next: next)
        }
    }
}