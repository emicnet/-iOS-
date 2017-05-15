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

class WebApiTests: XCTestCase {

    let callbackInput = ["from":"18612441783","to":"13910134045"]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
        let calldata = ["callBack":["from":"18612441783","to":"13910134045","appId":AccountInfo.appID]]
        let jsonData  = try! JSONSerialization.data(withJSONObject: calldata)
        XCTAssert(body==jsonData,"http body set wrong")
        //2 check http header
        let tmp = callbackURL.allHTTPHeaderFields
        XCTAssert(tmp != nil,"Failed to set header")
        let headers = tmp!
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
