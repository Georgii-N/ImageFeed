
import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case unauthorized
    case notFound
    case serverError
    case unknown
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if statusCode == 401 {
                    fulfillCompletion(.failure(NetworkError.unauthorized))
                } else if statusCode == 404 {
                    fulfillCompletion(.failure(NetworkError.notFound))
                } else if 500...599 ~= statusCode {
                    fulfillCompletion(.failure(NetworkError.serverError))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
