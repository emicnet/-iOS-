//
//  CallCenterBaseViewController.swift
//  WebApi
//
//  Created by 唐先生 on 17/4/28.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka

class CallCenterBaseViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self .setUpUI()
        
    }
    func setUpUI() {
        form +++
            Section("管理用户")
            <<< LabelRow("新增坐席") {
                $0.title = $0.tag
                }.onCellSelection { [weak self] (cell, row) in
                    let vc = NewUserAccountViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
            }
            +++ Section("呼叫中心\n新增的坐席必须激活才能呼出")
            <<< LabelRow("坐席激活"){
                $0.title = $0.tag
            }.onCellSelection({ [weak self]  (cell, row) in
               let vc = SignInViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            <<< LabelRow("坐席呼出") { row in
                row.title = row.tag
            
                }.onCellSelection { [weak self] (cell, row) in
                    
                    let vc = MakeCallViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
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
