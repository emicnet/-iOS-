//
//  WebApiTests.swift
//  WebApiTests
//
//  Created by jiaguolin on 2017/4/25.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import XCTest
@testable import WebApi

import Alamofire
import CoreTelephony

class WebApiTests: XCTestCase {
    //公司两个测试号码,实际使用时候需要把 from 替换成本机实际号码
    let callbackInput = ["from":"17710670549","to":"18512517915"]
    let callCenter =  CTCallCenter()
    var expection:XCTestExpectation?
    var phoneCall = false
    
    override func setUp() {
        super.setUp()
        callCenter.callEventHandler = { (call:CTCall) in
            log.debug(call.callState)
            if call.callState == CTCallStateIncoming {
                self.phoneCall = true
                self.expection?.fulfill()
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMD5() {
        let hello = "Hello"
        let md5 = hello.md5
        XCTAssert(md5 == "8b1a9953c4611296a827abf8c47804d7","\(hello) md5 is wrong")
    }
    
    func verifyCallbackURL(_ callbackURL:URLRequest,input:[String:String]) {
        //0 verify api url
        log.debug(callbackURL.url!.absoluteString)
        let urlString = "http://\(AccountInfo.serverAddress)/\(AccountInfo.apiVersion)/SubAccounts/\(AccountInfo.subAccountSid)/Calls/callBack?sig="
        XCTAssert(callbackURL.url!.absoluteString.hasPrefix(urlString),"Wrong base url")
        //1 check http body
        let body = callbackURL.httpBody
        var tmp = callbackInput
        tmp["appId"] = AccountInfo.appID
        //["callBack":["from":"17710670549","to":"18512517915","appId":AccountInfo.appID]]
        let calldata = ["callBack":tmp]
        let jsonData  = try! JSONSerialization.data(withJSONObject: calldata)
        XCTAssert(body==jsonData,"http body set wrong")
        //2 check http header
        let tmp2 = callbackURL.allHTTPHeaderFields
        XCTAssert(tmp2 != nil,"Failed to set header")
        let headers = tmp2!
        let accept = headers["Accept"]!
        XCTAssert(accept.contains("json"),"Failed to set json header")
        let auth = headers["Authorization"]
        XCTAssert(auth != nil,"Failed to set Authorization header")
        //3 check http method
        XCTAssert(callbackURL.httpMethod == "POST","We use post")
    }
    
    func testCallBackURLFromAlamofire () {
        let url = try! Router.Callback(callbackInput).asURLRequest()
        self.verifyCallbackURL(url, input: callbackInput);
    }
    
    func testCallBackURLFromDataTask () {
        let url = try! Router.Callback(callbackInput).urlRequest()
        self.verifyCallbackURL(url, input: callbackInput);
    }
    
    func testCallBackPhoneCall() {
        let apiRequest = AlaRequest.self
        var callID:String?
        //Need to create it here or got "API violation - call made to wait without any expectations having been set."
        expection = expectation(description: "We should get a phone call within 15 seconds")
        
        apiRequest.request(Router.Callback(callbackInput)) { (CallResult) in
            switch CallResult {
            case .fail:
                XCTFail("Should get a phone call, but api call failed")
            case .inCorrectCodeResult(let errorCode, let errorInfo):
                XCTFail("Although we made api called, server rejected us with \(errorCode) meaning \(errorInfo)")
            case .inCorrectResult:
                XCTFail("Server should be really wrong b/c we got respCode = 0, but not expected result!")
            case .succeed(let result):
                callID = result["callId"] as? String
                XCTAssert(callID != nil, "We got a callID \(callID!), but wait to see if we really got a phone call")
            }
            log.info("Important!! We are waiting for a phone call, so we can NOT call expection.fulfill() here as other normal async tests do")
            log.info("Otherwise waitForExpectations will run next, which defeats the whole purpose")
            log.info("So we need other indicator to show we got async result and call expection.fulfill() when we got phone call")
            //Do NOT call expection.fulfill() here
            //Call it in callCenter.callEventHandler
        }
        //15秒只是一个经验值，15内应该能回拨回来
        waitForExpectations(timeout: 15) { _ in
            if !self.phoneCall {
                log.debug("Got server respone but no phone call in 15 seconds, still a failure, but need to further check why")
                XCTFail("Got server response, but no phone call")
            }
        }
    }
}
