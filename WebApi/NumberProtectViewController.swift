//
//  NumberProtectViewController.swift
//  WebApi
//
//  Created by fcy on 17/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit
import Eureka

class NumberProtectViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "号码保护"
        self.view.backgroundColor = UIColor.white
        self .setUpUI()
        
    }
    func setUpUI()  {
        form +++
        Section()
            <<< LabelRow("号码保护对匹配") {
                $0.title = $0.tag
                
                } .onCellSelection { [weak self] (cell, row) in
            
                    let vc = NumberProtectDetailViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
            }
            <<< LabelRow("创建技能组") { row in
                row.title = row.tag
                
                } .onCellSelection { [weak self] (cell, row) in
                    
                    let vc = CreateGroupViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
            }
            <<< LabelRow("获取企业空闲号码") { row in
                row.title = row.tag
                } .onCellSelection { [weak self] (cell, row) in
                    let vc = GetFreeNumberViewController()
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
