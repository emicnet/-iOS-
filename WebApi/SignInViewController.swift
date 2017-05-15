//
//  SignInViewController.swift
//  WebApi
//
//  Created by 唐先生 on 17/5/9.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka
import PKHUD
class SignInViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    func setUpUI() -> Void {
        form +++
            Section()
            <<< TextRow() {
                $0.tag = "text"
                $0.title = "坐席编号:"
                $0.placeholder = "请输入编号"
            }
            <<< PhoneRow() {
                $0.tag = "number"
                $0.title = "坐席号码:"
                $0.placeholder = "请输入手机号"
            }
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "确认激活"
                }.onCellSelection({ (String, row) in
                    self .ensureToSignIn()
                })
    }
    
    func ensureToSignIn() {
        let row: TextRow? = form.rowBy(tag: "text")
        let text = row?.value
        
        let row2: PhoneRow? = form.rowBy(tag: "number")
        let telePhoneNum = row2?.value
        if (text == nil || telePhoneNum == nil) {
            HUD.flash(.label("编号或者号码不能为空"), delay: 4.0)
            return
        }
        
        let input = ["appId":AccountInfo.appID,
                     "workNumber":text!,
                     "deviceNumber":telePhoneNum!]
        apiRequest.request(Router.CallCenterSignIn(input)) { verify in
            guard case .succeed = verify else {
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
                return
            }
            HUD.flash(.label("添加成功"), delay: 4.0)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
