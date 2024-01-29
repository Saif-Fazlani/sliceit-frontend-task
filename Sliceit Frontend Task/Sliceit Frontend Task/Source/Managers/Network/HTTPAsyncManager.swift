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

class HTTPAsyncManager<T> where T: Codable {
    
    private let successCall: ((T) -> Void)
    private let failureCall: ((HTTPAsyncRequestError) -> Void)
    
    private let httpAsyncDispatcher: HTTPAsyncDispatcher<T>
    private let networkMonitor: NetworkMonitor
    
    init(success: @escaping (T) -> Void, failure: @escaping (HTTPAsyncRequestError) -> Void) {
        self.successCall = success
        self.failureCall = failure
        self.networkMonitor = NetworkMonitorImpl()
        self.httpAsyncDispatcher = HTTPAsyncDispatcher<T>()
    }
    
    func generateRequest(_ payload: ServicePayload) async throws {
        try networkMonitor.checkIfOnline()
        let token = UserDefaults.standard.authToken
        
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
        
        await execute(request: urlRequest)
    }
    
    private func execute(request: URLRequest) async {
        do {
            let (data, response) = try await dataTask(for: request)
            logPayload(request: request, response: (data, response))
            let parsedResponse = httpAsyncDispatcher.parse(data)
            processParsedResult(result: parsedResponse, statusCode: response.statusCode)
        } catch {
            failureCall(HTTPAsyncRequestError.unknown)
        }
    }
    
    private func processParsedResult(result: Result<T, HTTPAsyncRequestError>, statusCode: Int) {
        switch result {
        case .success(let response):
            let requestResult = httpAsyncDispatcher.verify(response: response, statusCode: statusCode)
            switch requestResult {
            case .success(let response):
                guard let data = response else {
                    failureCall(HTTPAsyncRequestError.empty)
                    return
                }
                successCall(data)
            case .failure(let error):
                failureCall(error)
            }
        case .failure(let error):
            failureCall(error)
        }
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
