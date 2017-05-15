//
//  GetFreeNumberViewController.swift
//  WebApi
//
//  Created by fcy on 17/4/28.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka
import PKHUD
import Alamofire

class GetFreeNumberViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "获取企业空闲号码"
        self .setUpUI()
    }
    func setUpUI()  {
        form +++
            Section()
   
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "获取空闲号码"
                }.onCellSelection({ (String, row) in
                    self .getFreeNumber()
                })

            +++ Section("获取的企业号码如下")

            <<< LabelRow() {
                $0.title = "还未获取"
                $0.tag = "numberLabel"
            }

    }
    
    func getFreeNumber() {

        let numberLabelRow: LabelRow? = form.rowBy(tag: "numberLabel")

        let dic  = ["appId": AccountInfo.appID]
        
        apiRequest.request(Router.GetFreeNumber(dic)) { (verify) in
            switch verify
            {
            case .fail:
                fallthrough
            case .inCorrectResult:
                numberLabelRow?.title = "获取失败"
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
            case .inCorrectCodeResult(let errorCode,let errorInfo):
                HUD.flash(.label(errorCode+":"+errorInfo), delay: 2.0)
            case .succeed(let result):
                numberLabelRow?.title = result["freeNumber"] as! String?
                numberLabelRow?.updateCell()
                HUD.flash(.label("获取号码成功"), delay: 2.0)
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
