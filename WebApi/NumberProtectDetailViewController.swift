//
//  NumberProtectDetailViewController.swift
//  WebApi
//
//  Created by fcy on 17/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import PKHUD
class NumberProtectDetailViewController: FormViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "体验中心"
        self.view.backgroundColor = UIColor.white
        self .setUpUI()
    }
    
    func setUpUI() {
        form +++
            Section("模拟房产买卖双方匿名通话")
            +++ Section("输入卖家与买家号码")
            <<< PhoneRow() {
                $0.tag = "number1"
                $0.title = "卖家手机"
                $0.placeholder = "请输入参会人的手机号"
            }
            <<< PhoneRow() {
                $0.tag = "number2"
                $0.title = "买家手机"
                $0.placeholder = "请输入参会人的手机号"
            }

            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "号码匹配"
                }.onCellSelection({ (String, row) in
                    self .numberMatching()
                })
    }
    
    func numberMatching() {

        let row: PhoneRow? = form.rowBy(tag: "number1")
        let telePhoneNum1 = row?.value
        
        let row2: PhoneRow? = form.rowBy(tag: "number2")
        let telePhoneNum2 = row2?.value
        
        if telePhoneNum1 == nil || telePhoneNum2 == nil {
            print("请输入手机号码")
            return
        }

        let input = ["numberA":telePhoneNum1!,"numberB":telePhoneNum2!]
        apiRequest.request(Router.CreateNumberPair(input)) { verify in
            switch verify{
            case .fail:
                fallthrough
            case .inCorrectResult:
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
            case .inCorrectCodeResult(let errorCode,let errorInfo):
                HUD.flash(.label(errorCode+":"+errorInfo), delay: 2.0)
            case .succeed:
                HUD.flash(.label("号码匹配成功"), delay: 4.0)
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
