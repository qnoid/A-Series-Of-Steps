typealias InputOutput = [AnyHashable : Any]
typealias SuccessfulStep = (_ next: Step?) -> Step
typealias Step = (_ io: InputOutput) -> Swift.Void