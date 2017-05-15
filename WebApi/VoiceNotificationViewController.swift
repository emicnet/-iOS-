//
//  VoiceNotificationViewController.swift
//  WebApi
//
//  Created by 唐先生 on 17/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import PKHUD
import Eureka

class VoiceNotificationViewController: FormViewController {

    var textID = ""//语音文本的ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "语音通知"
        self .setUpUI()
        
    }
    func setUpUI()  {
        form +++
            Section("模拟信用卡账单电话自动语音提醒")
            <<< PhoneRow() {
                $0.tag = "number"
                $0.title = "手机号:"
                $0.placeholder = "请输入手机号"
            }
           
            +++ Section("语音通知（文本可手动修改）")
            
            <<< TextAreaRow() {
                $0.tag = "text"
                $0.placeholder = "尊敬的张三客户您好，您的尾号为2093的农业银行信用卡本期应该还款2299"
            }

             +++ Section(" 演示环境限100个字以内")
      
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "确认接收语音通知"
        }.onCellSelection({ (cell, row) in
            self.uploadText()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func uploadText() {
        let row: TextAreaRow = form.rowBy(tag: "text")!
        var text = row.value
        if text == nil {
            text = row.placeholder!
        }
        let input = ["text":text!,"maxAge":"1800"]
        apiRequest.request(Router.UploadText(input)) { verify in
            guard case .succeed(let result) = verify,
                let text = result["textId"] as? String else {
                    log.warning("No text ID return")
                    HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
                    return
            }
            self.textID  = text
            HUD.show(.label("语音消息已成功发送服务器"))
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                self.requsetToNotify()
            })
        }
    }
    
    func requsetToNotify() -> Void {
        let row: PhoneRow? = form.rowBy(tag: "number")
        let telePhoneNum = row?.value
        
        if telePhoneNum == nil {
            HUD.flash(.label("请输入手机号码"))
            return
        }
        let input = ["textId":self.textID,"to":telePhoneNum!]

        apiRequest.request(Router.VoiceNotification(input)) { verify in
            guard case .succeed = verify else {
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
                return
            }
            HUD.flash(.label("请您注意接听来电"), delay: 4.0)

        }
    }
}
