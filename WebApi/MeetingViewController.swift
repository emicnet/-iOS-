//
//  MeetingViewController.swift
//  WebApi
//
//  Created by jiaguolin on 2017/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import PKHUD
import Eureka

class MeetingViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor  = UIColor.white
        
        self.title = "电话会议"
        self .setUI()
    }
    func setUI() {
        form +++
            Section("创建会议")
            <<< PhoneRow() {
                $0.tag = "number1"
                $0.title = "参会人1："
                $0.placeholder = "请输入参会人的手机号"
            }
            <<< PhoneRow() {
                $0.tag = "number2"
                $0.title = "参会人2："
                $0.placeholder = "请输入参会人的手机号"
            }
            <<< PhoneRow() {
                $0.tag = "number3"
                $0.title = "参会人3："
                $0.placeholder = "请输入参会人的手机号"
            }
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "创建会议"
            }.onCellSelection({ (string, row) in
                    self.creatMeeting()
            })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     func creatMeeting() {
        let row: PhoneRow? = form.rowBy(tag: "number1")
        let telePhoneNum1 = row?.value
        
        let row2: PhoneRow? = form.rowBy(tag: "number2")
        let telePhoneNum2 = row2?.value
        
        let row3: PhoneRow? = form.rowBy(tag: "number3")
        let telePhoneNum3 = row3?.value
        
        if telePhoneNum1 == nil || telePhoneNum2 == nil || telePhoneNum3 == nil{

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
        
        let input = ["from":telePhoneNum1!,"to":telePhoneNum2! + "," + telePhoneNum3!]

        apiRequest.request(Router.Meeting(input)) { verify in
            if case .succeed = verify {
                HUD.flash(.label("请您注意接听来电"), delay: 4.0)
            }else if case .inCorrectCodeResult(let errorCode, let errorInfo) = verify
            {
                HUD.flash(.label(errorCode+":"+errorInfo), delay: 2.0)
            }else
            {
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
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
