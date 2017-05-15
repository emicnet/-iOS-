//
//  AFNRequest.swift
//  WebApi
//
//  Created by qiulang on 2017/5/9.
//  Copyright © 2017年 emicnet. All rights reserved.
//
import Foundation

public enum HTTPMethodType: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}


extension Router {
    func urlRequest() throws -> URLRequest {
        let tmp = self.myURLRequest()
        var request = tmp.0
        let params = tmp.1
        let jsonData  = try JSONSerialization.data(withJSONObject: params)
        let method = request.httpMethod!
        if params.count > 0 &&  method == "POST"{
            request.httpBody = jsonData
        }
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request;
    }
}

class TaskRequest:APIRequest {
     static func request(_ requestRouter: Router,completionHandler: @escaping (CallResult)->Void) -> Void {
        let urlRequest = try! requestRouter.urlRequest()
        var result = CallResult.fail
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    log.warning("Failed to get response: \(String(describing: error))")
                    completionHandler(CallResult.fail)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                    log.warning("request failed,response: \(String(describing: response))")
                    completionHandler(CallResult.fail)
                    return
                }
                log.debug(httpResponse)
                do {
                    let responseJSON:[String: Any] = try JSONSerialization.jsonObject(with: data!,
                                                                                       options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as! [String: Any]
                    result = self.verify(responseJSON, request: requestRouter)
                    completionHandler(result)
                } catch {
                    log.warning("Failed to parse the JSON data\(String(describing: data))")
                    completionHandler(CallResult.fail)
                }
            }
        }
        task.resume()
    }
}
