//
//  TableViewController.swift
//  WebApi
//
//  Created by jiaguolin on 2017/4/27.
//  Copyright © 2017年 emicnet. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let sectionTitles = ["语音通讯功能","语音文件管理功能","云总机和企业用户管理功能","子账户管理功能","呼叫中心"]
    
    let rowData = [["语音验证码","APP双向呼叫","电话会议"],["语音通知"],["号码保护"],["添加子账户"],["呼叫中心"]]
    
    var demoData:[String:(String,String)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        demoData = [rowData[0][2]:("MeetingViewController","Calls/callBack"),
                    rowData[0][1]:("CallBackViewController","Calls/callBack"),
                    rowData[0][0]:("VoiceCodeViewController","Calls/voiceCode"),
                    rowData[1][0]:("VoiceNotificationViewController","Calls/voiceNotify"),
                    rowData[2][0]:("NumberProtectViewController","Enterprises/createNumberPair"),
                    rowData[3][0]:("CreateSubAccountViewController","Applications/createSubAccount"),
                    rowData[4][0]:("CallCenterBaseViewController","CallCenter/callOut&CallCenter/signIn")
        ]
        
        self.navigationItem.title = "API演示"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = rowData[indexPath.section][indexPath.row]
        let api = demoData[title]!.1
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = api
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = rowData[indexPath.section][indexPath.row]
        let storyboardID = demoData[title]!.0
        //Swift classes are namespaced
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        guard let myClassType = NSClassFromString(nameSpace + "." + storyboardID) as? UIViewController.Type else{
            return
        }
        let childController = myClassType.init()
        self.navigationController?.pushViewController(childController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
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
