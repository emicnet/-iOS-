//
//  AllSubCountViewController.swift
//  WebApi
//
//  Created by jiaguolin on 2017/4/28.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import Eureka

class AllSubCountViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++
            Section("获取的子账户显示如下")
            <<< LabelRow() {
                $0.tag = "account"
                $0.title = "子账户:"
        }
        self.view.backgroundColor = UIColor.white
        let row: LabelRow? = form.rowBy(tag: "account")

        let input = ["":""]
        apiRequest.request(Router.SubAccountList(input)) { verify in
            switch verify {
            case .fail:
                fallthrough
            case .inCorrectResult:
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
            case .inCorrectCodeResult(let errorCode,let errorInfo):
                HUD.flash(.label(errorCode+":"+errorInfo), delay: 2.0)
            case .succeed(let result):
                if result.count == 0 {
                    row?.title = "目前没有子账号"
                } else {
                    let account = result["subAccounts"] as! [[String:Any]]
                    row?.title = "目前有\(account.count)个子账号"
                }
                row?.updateCell( )
                HUD.flash(.label("查询子账户成功"), delay: 2.0)
            }
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
