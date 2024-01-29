//
//  HTTPAsyncManager.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 29/01/2024.
//

import Foundation

typealias ResultHandler<T> = (ResultType<T>) -> Void
typealias URLResponse = Result<(data: Data, response: HTTPURLResponse), HTTPAsyncRequestError>

enum ResultType<T> {
    case success(T)
    case failure(HTTPAsyncRequestError)
}

class HTTPAsyncManager<Response: Decodable> {
    
    private let httpAsyncDispatcher: HTTPAsyncDispatcher<Response>
    private let networkMonitor: NetworkMonitor
    
    init() {
        self.networkMonitor = NetworkMonitorImpl()
        self.httpAsyncDispatcher = HTTPAsyncDispatcher<Response>()
    }
    
    func generateRequest(_ payload: ServicePayload) async throws -> Response {
        try networkMonitor.checkIfOnline()
        
        let url = APIConstants.baseURL + payload.getEndPoint().orNil
        let urlWithPercentEscapes = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let requestURL = URL(string: urlWithPercentEscapes.orNil) else {
            throw HTTPAsyncRequestError.urlConstructionFailed
        }
        
        let urlRequest = URLRequest(url: requestURL,
                                    method: payload.getRequestType(),
                                    header: payload.getHeaders(),
                                    body: payload.getParameters(),
                                    timeoutInterval: payload.getTimeoutInterval())
        
        return try await execute(request: urlRequest)
    }
    
    private func execute(request: URLRequest) async throws -> Response {
        do {
            let (data, response) = try await dataTask(for: request)
            logPayload(request: request, response: (data, response))
            let parsedResponse = try await httpAsyncDispatcher.parse(data)
            return try await processParsedResult(result: parsedResponse, statusCode: response.statusCode)
        } catch {
            throw HTTPAsyncRequestError.unknown
        }
    }
    
    private func processParsedResult(result: Response, statusCode: Int) async throws -> Response {
        let responseResult = try await httpAsyncDispatcher.verify(response: result, statusCode: statusCode)
        return responseResult
    }
    
    private func logPayload(request: URLRequest, response: (data: Data, response: HTTPURLResponse)) {
        print("------------------------------------------------")
        print("STATUS_CODE: \(response.response.statusCode)")
        print("ROUTE: \((request.url?.absoluteString).orNil)")
        print("METHOD: \(request.httpMethod.orNil)")
        print("HEADERS: \((request.allHTTPHeaderFields?.getJsonFromDictionary).orNil)")
        
        if let parameter = request.httpBody?.getJSONFromData {
            print("PARAMETERS: \(parameter)")
        }
        
        if let dataJsonResponse = response.data.getJSONFromData {
            print(("RESPONSE: \(dataJsonResponse)"))
        }
        print("------------------------------------------------")
    }
    
}

extension HTTPAsyncManager {
    func dataTask(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPAsyncRequestError.badResponse
            }
            return (data, httpResponse)
        } catch {
            throw HTTPAsyncRequestError.networkError(error.localizedDescription)
        }
    }
}
