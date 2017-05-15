//
//  Router.swift
//  WebApi
//
//  Created by qiulang on 2017/5/3.
//  Copyright © 2017年 emicnet. All rights reserved.
//
import Foundation

enum Router {
    case Callback([String:String])
    case Meeting([String:String])
    case VoiceCode([String:String])
    case UploadText([String:String])
    case VoiceNotification([String:String])
    case CreateSubAccount([String:String])
    case SubAccountList([String:String])
    case CreateUser([String:String])
    case CreateNumberPair([String:String])
    case CreateGroup([String:String])
    case GetFreeNumber([String:String])
    case CallCenterSignIn([String:String])
    case CallCenterCallOut([String:String])
    
    
    static let baseURLPath = "http://\(AccountInfo.serverAddress)/\(AccountInfo.apiVersion)/"
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter
    }()
    
    func myURLRequest() -> (URLRequest,[String:[String:String]]) {
        var urlString = Router.baseURLPath;
        var sid = AccountInfo.subAccountSid
        var token = AccountInfo.subAuthToken
        var accountType = "SubAccounts"
        var param0 = ["appId":AccountInfo.appID]
        var params:[String:[String:String]] = [:]
        
        func setAccount() { //使用主账号认证还是子账号认证，参见api文档
            sid = AccountInfo.accountSid
            token = AccountInfo.authToken
            accountType = "Accounts"
        }
        
        func updateInput(_ input:[String:String], key:String) {
            input.forEach { (key, value) in param0[key] = value }
            params = [key: param0]
        }
        
        switch self {
        case .Callback(let input), .Meeting(let input):
            updateInput(input,key:"callBack")
            urlString += "\(accountType)/\(sid)/Calls/callBack?sig="
        case .VoiceCode(let input):
            updateInput(input,key:"voiceCode")
            urlString += "\(accountType)/\(sid)/Calls/voiceCode?sig="
        case .VoiceNotification(let input):
            updateInput(input,key:"voiceNotify")
            urlString += "\(accountType)/\(sid)/Calls/voiceNotify?sig="
        case .UploadText(let input):
            setAccount()
            updateInput(input,key:"uploadText")
            urlString += "\(accountType)/\(sid)/Voice/uploadText?sig="
        case .CreateSubAccount(let input):
            setAccount()
            updateInput(input, key:"createSubAccount")
            urlString += "\(accountType)/\(sid)/Applications/createSubAccount?sig="
        case .SubAccountList(let input):
            setAccount()
            updateInput(input, key: "subAccountList")
            urlString += "\(accountType)/\(sid)/Applications/subAccountList?sig="
        case .CreateNumberPair(let input):
            updateInput(input, key: "createNumberPair")
            urlString += "\(accountType)/\(sid)/Enterprises/createNumberPair?sig="
        case .CreateUser(let input):
            updateInput(input, key: "createUser")
            urlString += "\(accountType)/\(sid)/Enterprises/createUser?sig="
        case .CreateGroup(let input):
            updateInput(input, key: "createGroup")
            urlString += "\(accountType)/\(sid)/Enterprises/createGroup?sig="
        case .GetFreeNumber(let input):
            updateInput(input, key: "freeNumbers")
            urlString += "\(accountType)/\(sid)/Enterprises/freeNumbers?sig="
        case .CallCenterSignIn(let input):
            updateInput(input, key: "signIn")
            urlString += "\(accountType)/\(sid)/CallCenter/signIn?sig="
        case .CallCenterCallOut(let input):
            updateInput(input, key: "callOut")
            urlString += "\(accountType)/\(sid)/CallCenter/callOut?sig="
        }
        
        //获取当前时间
        let now = Date()
        let dateString = Router.formatter.string(from: now)
        let sig = sid + token + dateString
        urlString += sig.md5.uppercased()
        log.debug(urlString)
        //<账号Id:时间戳>，用base64编码；账号Id与sigParameter中相同
        let authorization = sid + ":" + dateString
        let plainData = authorization.data(using: String.Encoding.utf8)!
        let base64String  = plainData.base64EncodedString()
        var request = URLRequest(url: URL(string: urlString)!)
        //所有API目前都使用post
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(base64String, forHTTPHeaderField: "Authorization")
        return (request,params);
    }
}

enum CallResult {
    case fail
    case inCorrectResult([String: Any])
    case inCorrectCodeResult(errorCode:String, errorInfo:String)
    case succeed([String: Any])
}

protocol APIRequest {
    static func request(_ requestRouter: Router,completionHandler: @escaping (CallResult)->Void) -> Void
}

