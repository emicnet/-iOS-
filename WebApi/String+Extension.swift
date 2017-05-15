//
//  String+Extension.swift
//  WebApi
//
//  Created by jiaguolin on 2017/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit

extension String {
    //http://stackoverflow.com/questions/32163848/how-to-convert-string-to-md5-hash-using-ios-swift
    var md5 : String{
        //1. Create md5 data from a string
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        //2. Covert the md5 data to a hex string
        let md5Hex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }
}
