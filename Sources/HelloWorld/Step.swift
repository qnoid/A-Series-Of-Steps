infix operator -->: AssignmentPrecedence

public typealias InputOutput = [AnyHashable : Any]
public typealias Step = (_ io: InputOutput) -> Swift.Void

public struct SuccessfulStep {
    let success: (_ next: Step?) -> Step


	//https://github.com/apple/swift-evolution/blob/0c36ce83b6b6bd61a63fa048554fb3e5a9f01ad9/proposals/0253-callable.md
    func call(_ next: Step?) -> Step {
        return success(next)
    }
}

extension SuccessfulStep {
    static func --> (successful: SuccessfulStep, next: @escaping Step) -> Step {
        return successful.call(next)
    }
}
