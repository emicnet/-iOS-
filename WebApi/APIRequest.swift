//
//  APIRequest.swift
//  WebApi
//
//  Created by Cotin on 05/05/2017.
//  Copyright © 2017 emicnet. All rights reserved.
//

import UIKit
extension APIRequest {
    //统一处理web返回数据，生成结果CallResult交由UI进一步处理
    static func verify(_ responseJSON:[String: Any], request:Router) -> CallResult {
        guard let first = responseJSON.first, first.key == "resp", //Only ONE key:value pair
            let resp = first.value as? [String: Any], //resp & respCode is defined in API document
            let code = resp["respCode"] as? Int else {
                log.warning("Not our agreement data!")
                return .fail
        }
        if code != 0 {
            log.warning("Although we succeeded in making web api call but the call result is incorrect:\(code)")
            log.info("Need to refer to the API document for \(code)'s meaning")
            return .inCorrectCodeResult(errorCode: "\(code)", errorInfo: self.errorInfo(errorCode: code))
        }
        //Further verify each enum case
        var returnValue:[String:Any]
        switch request {
        case .Callback,.Meeting:
            guard let result = resp["callBack"] as? [String:Any] else {
                log.warning("Unless server is really wrong, this should NOT happen")
                return .inCorrectResult(resp)
            }
            let callID = result["callId"] as! String
            log.info("As we get call ID \(callID) so the phone call should reach us shortly");
            returnValue = result;
        case .VoiceCode:
            guard let result = resp["voiceCode"] as? [String:Any] else {
                return .inCorrectResult(resp)
            }
            let callID = result["callId"] as! String
            log.info("As we get call ID \(callID) so the phone call should reach us shortly");
            returnValue = result;
        case .UploadText:
            guard let result = resp["uploadText"] as? [String:Any],
            let text = result["textId"] as? String else {
                log.warning("No text ID return")
                return .inCorrectResult(resp)
            }
            log.debug("We will use this text ID\(text) to let server notify us")
            returnValue = result;
        case .VoiceNotification:
            guard let result = resp["voiceNotify"] as? [String:Any],
            let callID = result["callId"] as? String
            else {
                log.warning("Why no call ?")
                return .inCorrectResult(resp)
            }
            let status = result["status"] as? Int
            log.info("As we have call id \(callID) and its status is \(status ?? 0)");
            returnValue = result;
        case .CreateGroup:
            guard let result = resp["createGroup"] as? [String:Any],
            let gID = result["gid"] as? String
            else {
                log.warning("CreatGroup Failed")
                return .inCorrectResult(resp)
            }
            log.info("we have create group success and gid : \(gID)");
            returnValue = result;
        case .CreateNumberPair:
            guard let userNumber = resp["useNumber"] as? String
            else {
                log.warning("CreateNumberPair Failed")
                return .inCorrectResult(resp)
            }
            log.info("CreateNumberPair Success And useNumber: \(userNumber)")
            returnValue = ["userNumber":userNumber]
        case .CreateUser:
            guard let result = resp["createUser"] as? [String:Any],
            let number = result["userNumber"]
            else {
                log.warning("createUser Failed")
                return .inCorrectResult(resp)
            }
            log.info("createUser Success And number: \(number)")
            returnValue = result
        case .CreateSubAccount:
            guard let result = resp["createSubAccount"] as?[String:Any],
            let subAccountSid = result["subAccountSid"],
            let subAccountToken = result["subAccountToken"]
            else {
                log.warning("CreateSubAccount Failed")
                return .inCorrectResult(resp)
            }
            log.info("CreateSubAccount Success And subAccountSid: \(subAccountSid) and subAccountToken \(subAccountToken)")
            returnValue = result
        case .SubAccountList:
            guard let result = resp["subAccountList"] as? [String:Any],
            let number = result["number"] as? Int
            else {
                log.warning("Get SubAccountList Failed")
                return .inCorrectResult(resp)
            }
            if number == 0 {
                return .succeed([:])
            }
            log.info("Get SubAccountList Success And count: \(number)")
            let accounts = result["subAccounts"] as! [[String:Any]]
            returnValue = ["subAccounts":accounts]
        case .CallCenterSignIn:
            returnValue = [:]
        case .CallCenterCallOut:
            guard let result = resp["callOut"] as?[String:Any],
            let callID = result["callId"] as?String
            else {
                log.warning("CallOut Failed")
                return .inCorrectResult(resp)
            }
            log.info("CallOut success and callID : \(callID)")
            returnValue = result
        case .GetFreeNumber:
            guard let result = resp["freeNumbers"] as? [String:Any],
            let count = result["count"] as? Int
            else {
                log.warning("GetFreeNumber Failed")
                return .inCorrectResult(resp)
            }
            if count == 0 {
                return .succeed(["freeNumber":"当前企业无空闲的号码"])
            }
            //Since count >0
            let numberd = result["numbers"] as! [String]
            let numberString: String = numberd.joined(separator: ";")
            log.info("GetFreeNumber succeeded and the count is: \(count)")
            returnValue =  ["freeNumber":numberString]
        }
        return .succeed(returnValue)
    }

    
    static func errorInfo(errorCode:Int) -> String {
        var message:String
        switch errorCode {
        case 101000:
            message = "HTTP请求包头无Authorization参数"
        case 101001:
            message = "HTTP请求包头无Content-Length参数"
        case 101002:
            message = "Authorization参数Base64解码失败"
        case 101003:
            message = "Authorization参数解码后的格式错误"
        case 101004:
            message = "Authorization参数不包含认证账户ID"
        case 101005:
            message = "Authorization参数不包含时间戳"
        case 101006:
            message = "Authorization参数的账户ID不正确"
        //请求体相关错误
        case 101012:
            message = "HTTP请求的sig参数校验失败"
        case 101013:
            message = "HTTP请求包体没有任何内容"
        case 101014:
            message = "HTTP请求包体XML格式错误"
        case 101015:
            message = "HTTP请求包体XML包中的功能名称错误"
        case 101016:
            message = "HTTP请求包体XML包无任何有效字段"
        case 101017:
            message = "HTTP请求包体Json格式错误"
        case 101018:
            message = "HTTP请求包体Json包中的功能名称错误"
        case 101019:
            message = "HTTP请求包体Json包无任何有效字段"
        case 101020:
            message = "HTTP请求包体中缺少AppId"
        //号码匹配相关
        case 101045:
            message = "HTTP请求包体中缺少numberA"
        case 101046:
            message = "HTTP请求包体中缺少numberB"
        case 101047:
            message = "numberA或numberB格式错误"
        //语音验证码相关
        case 102001:
            message = "账户关联企业错误"
        //坐席
        case 102500:
            message = "呼叫转移座席工号不存在"
         
        case 101032,
             101033,
             101034:
            message = "被叫号码非法"
            
        case 101035,
             101036,
             101037:
            message = "主叫号码非法"
        default:
            message = "未知错误码"
        }
        return message
    }
}
