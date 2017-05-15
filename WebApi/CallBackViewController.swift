//
//  CallBackViewController.swift
//  WebApi
//
//  Created by jiaguolin on 2017/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import PKHUD
import Eureka

class CallBackViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "回拨"
        self .setUI()
        
    }
    func setUI() {
        form +++
            Section("双向呼叫")
            <<< PhoneRow() {
                $0.tag = "number1"
                $0.title = "号码1:"
                $0.placeholder = "请输入您的手机号"
            }
            <<< PhoneRow() {
                $0.tag = "number2"
                $0.title = "号码2:"
                $0.placeholder = "请输入您的另一个手机号"
            }
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "发起双向呼叫"
                }.onCellSelection({ (string, row) in
                    self.callBackAction()
                    
                })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func callBackAction() {
        
        /*
         POST /20150829/Accounts/9b7aaa20893a636e4bfc9fcf7504cb8a/Calls/callBack?sig=2367E5FC0879F9BD0F7CE3E7A37D3A0D
         Host:api.emic.com.cn
         Accept:application/json
         Content-Type:application/json;charset=utf-8
         Authorization: OWI3YWFhMjA4OTNhNjM2ZTRiZmM5ZmNmNzUwNGNiOGE6MjAxNTA5MDIwOTM5NTY=
         
         {
         "callBack"   : {
             "appId"      : "b23abb6d451346efa13370172d1921ef",
             "from"       : "13801289896",
             "to"         : "15689089874",
             "userData"   : "12345678"
             }
         }
     */
        
        let row: PhoneRow? = form.rowBy(tag: "number1")
        let telePhoneNum1 = row?.value
        
        let row2: PhoneRow? = form.rowBy(tag: "number2")
        let telePhoneNum2 = row2?.value
        
        if telePhoneNum1 == nil || telePhoneNum2 == nil {

            let alertController = UIAlertController(title: "提示",
                                                    message: "请输入正确的号码", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                print("点击了确定")
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let input = ["from":telePhoneNum1!,"to":telePhoneNum2!]
        apiRequest.request(Router.Callback(input)) { verify in
            switch verify {
            case .fail:
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
            case .inCorrectResult(let errorResult):
                HUD.flash(.label("调用成功,但是返回的结果错误:\(errorResult)"), delay: 2.0)
            case .succeed:
                HUD.flash(.label("请您注意接听来电"), delay: 4.0)
            case .inCorrectCodeResult(let errorCode,let errorInfo):
                HUD.flash(.label(errorCode+":"+errorInfo), delay: 2.0)
            }
        }
    }
}
