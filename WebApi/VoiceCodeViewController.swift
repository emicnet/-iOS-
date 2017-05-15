//
//  VoiceCodeViewController.swift
//  WebApi
//
//  Created by 唐先生 on 17/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import Eureka

class VoiceCodeViewController: FormViewController {

    var code = " "//随机验证码 4位数
    var to = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         code = String.init(format: "%04d", (arc4random()%10000))
        self .setUI()
    }
    func setUI() {
        form +++
            Section("体验语音验证码")
                <<< PhoneRow() {
                    $0.tag = "telePhoneNum"
                    $0.title = "手机号："
                    $0.placeholder = "请输入您的手机号"
                }
            +++ Section()
                <<< PhoneRow() {
                    $0.tag = "codeField"
                    $0.title = "收到的验证码"
                    $0.placeholder = "请输入收到的验证码"
                }
            +++ Section()
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "语音接收"
                    }.onCellSelection({ (string, row) in
                        self.sendRequest()
                    })
            +++ Section()
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "验证"
                }.onCellSelection({ (string, row) in
                    self.check()
                })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendRequest() {
        let row: PhoneRow? = form.rowBy(tag: "telePhoneNum")
        let telePhoneNum = row?.value
        
        if telePhoneNum==nil {
            HUD.flash(.label("电话号码不能为空"),delay:2.0)
            return;
        }

        self.to = telePhoneNum!
        _ = CallResult.fail

        let input = ["verifyCode":self.code,"to":self.to]
        apiRequest.request(Router.VoiceCode(input)) { verify in
            guard case .succeed = verify else {
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
                return
            }
            HUD.flash(.label("请您注意接听来电"), delay: 4.0)
        }
    }
    
    
    func check() {
        let row: PhoneRow? = form.rowBy(tag: "codeField")
        let codeField = row?.value
        if codeField == nil{
            HUD.flash(.label("验证码不能为空"))
            return
        }
        let result = codeField!==self.code
        if result==true
        {
            HUD.flash(.label("验证通过"),delay:2.0)
        }else
        {
            HUD.flash(.label("验证失败"),delay:2.0)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
