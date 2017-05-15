//
//  CreateGroupViewController.swift
//  WebApi
//
//  Created by fcy on 17/4/28.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import PKHUD
class CreateGroupViewController: FormViewController {


    @IBOutlet weak var groupName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "创建技能组"
        self .setUpUI()
    }
    
    func setUpUI()  {
        form +++
            Section("请输入创建的技能组的名称")
            <<< TextRow() {
                $0.tag = "text"
                $0.title = ""
                $0.placeholder = "请输入名称"
            }
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "创建技能组"
                }.onCellSelection({ (String, row) in
                    self .createGroupAction()
                })
    }
    
    func createGroupAction() {
        let row: TextRow? = form.rowBy(tag: "text")
        let text = row?.value
        
        if text == nil{
            print("未输入创建的技能组名称")
            return
        }

        let input = ["groupName":text!]
        apiRequest.request(Router.CreateGroup(input)) { verify in
            switch verify{
            case .fail:
                fallthrough
            case .inCorrectResult:
                HUD.flash(.label("调用失败，请通过日志查询具体原因"), delay: 2.0)
            case .inCorrectCodeResult(let errorCode,let errorInfo):
                HUD.flash(.label(errorCode+":"+errorInfo), delay: 2.0)
            case .succeed:
                HUD.flash(.label("创建技能组成功"), delay: 4.0)
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
