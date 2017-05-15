//
//  AlaRequest.swift
//  WebApi
//
//  Created by qiulang on 2017/5/9.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import Alamofire

extension Router: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let request = self.myURLRequest()
        let encoding = JSONEncoding.default
        return try encoding.encode(request.0, with: request.1)
    }
}

class AlaRequest: APIRequest {
    static func request(_ requestRouter: Router,completionHandler: @escaping (CallResult)->Void) -> Void {
        var result = CallResult.fail
        Alamofire.request(requestRouter)
            .responseJSON { response in
                log.debug(response)
                guard response.result.isSuccess else {
                    log.warning("Failed to get response: \(String(describing: response.result.error))")
                    completionHandler(.fail)
                    return
                }
                guard let responseJSON = response.result.value as? [String: Any] else {
                    log.warning("Not our agreement data!")
                    completionHandler(.fail)
                    return
                }
                result = self.verify(responseJSON,request:requestRouter)
                completionHandler(result)
        }
    }
}
