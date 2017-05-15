//
//  CreateSubAccountViewController.swift
//  WebApi
//
//  Created by jiaguolin on 2017/4/28.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import PKHUD

class CreateSubAccountViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self .setUI()
    
    }

    func setUI() {
        
        form +++
            Section()
            <<< TextRow() {
                $0.tag = "name"
                $0.title = "账户昵称"
                $0.placeholder = "请输入账户昵称"
            }
            <<< PhoneRow() {
                $0.tag = "number"
                $0.title = "手机号码"
                $0.placeholder = "请输入手机号"
            }
            <<< EmailRow() {
                $0.tag = "email"
                $0.title = "电子邮箱"
                $0.value = "a@b.com"
            }
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "创建子账户"
        }.onCellSelection({ (String, row) in
            self .createSubAccount()
        })
            +++ Section()
            <<< ButtonRow() { row in
                row.title = "获取所有子用户"
                }.onCellSelection { [weak self] (cell, row) in
                    let vc = AllSubCountViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    HUD.show(.label("查询中"))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func createSubAccount() {
        let row: TextRow? = form.rowBy(tag: "name")
        let name = row?.value
        
        let row2: PhoneRow? = form.rowBy(tag: "number")
        let number = row2?.value
        
        let row3: EmailRow? = form.rowBy(tag: "email")
        let email = row3?.value
        if name == nil || number == nil || email == nil {
             HUD.flash(.label("输入有误"))
            return
        }
        let input = ["nickName":name!,"mobile":number!,"email":email!]
        apiRequest.request(Router.CreateSubAccount(input)) { verify in
            switch verify{
            case .fail:
                fallthrough
            case .inCorrectResult:
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
            case .inCorrectCodeResult(let errorCode,let errorInfo):
                HUD.flash(.label(errorCode+":"+errorInfo), delay: 2.0)
            case .succeed:
                HUD.flash(.label("创建子账户成功"), delay: 4.0)
            }
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
