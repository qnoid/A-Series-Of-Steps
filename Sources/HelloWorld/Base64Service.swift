import Foundation

class Base64Service  {

    typealias DecodeCompletionHandler = (Result) -> Void

    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func decode(queue: DispatchQueue? = nil, encoded message: String, completionHandler: @escaping Base64Service.DecodeCompletionHandler) {

        var request = URLRequest(url: URL(string: "https://httpbin.org/base64/\(message)")!)
        request.httpMethod = "GET"
        request.addValue("text/html", forHTTPHeaderField: "accept")
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                preconditionFailure()
            }
        
            switch (response.statusCode) {
            case 200:
                if let data = data, let message = String(data: data, encoding: .utf8) {
                    (queue ?? DispatchQueue.main).async {
                        completionHandler(.success(message: message))
                    }
                }
            default:
                (queue ?? DispatchQueue.main).async {
                    completionHandler(.failure)
                }
            }
        }.resume()
    }
}