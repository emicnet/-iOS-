//
//  MakeCallViewController.swift
//  WebApi
//
//  Created by 唐先生 on 17/4/28.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import PKHUD

class MakeCallViewController: FormViewController{

    var userList:NSArray? = nil
    
    var userID:String = ""
    
    @IBOutlet weak var toNum: UITextField!

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var showLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let list = UserDefaults.standard.value(forKey: "userList")
        if list == nil
        {
            self.userList=[]

        }else
        {
            self.userList = list as! NSArray?
        }
        self.setUpUI()
        
    }
    func setUpUI()  {
    
        form +++
            Section("请选择呼叫的坐席")
            <<< PushRow<String>{
                $0.tag = "userID"
                $0.title = "当前坐席:"
                if  (self.userList != nil  && self.userList?.count != 0){
                   $0.options = self.userList as! [String]
                }else{
                    HUD.flash(.label("当前没有可用坐席"), delay: 2.0)
                }
            }.onChange({ (row) in
                 row.validationOptions = .validatesOnChange
                 self.userID = row.value!
            })
            +++ Section()
            <<< PhoneRow() {
                $0.tag = "number"
                $0.title = "呼叫号码"
                $0.placeholder = "请输入手机号"
            }

            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "呼叫"
                }.onCellSelection({ (String, row) in
                    self .makeCall()
        })
    }
    
    func makeCall() {
        
        let row: PhoneRow? = form.rowBy(tag: "number")
        let telePhoneNum = row?.value
        if (self.userID == ""){
            HUD.flash(.label("工号不能为空"), delay: 4.0)
            return;
        }
        if (telePhoneNum == nil ){
            HUD.flash(.label("拨打号码不能为空"), delay: 4.0)
            return;
        }
        
        let input = ["appId":AccountInfo.appID,"workNumber":self.userID,"to":telePhoneNum!]
        apiRequest.request(Router.CallCenterCallOut(input)) { verify in
            guard case .succeed = verify else {
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
                return
            }
            HUD.flash(.label("请您注意接听来电"), delay: 4.0)
        }
    }
    
}
