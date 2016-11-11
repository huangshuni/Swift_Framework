//
//  ViewController.swift
//  SN_SWIFT_Framwork
//
//  Created by huangshuni on 2016/11/11.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    lazy var tableView : UITableView = {
        let innerTableView:UITableView = UITableView.init(frame: self.view.frame, style: UITableViewStyle.plain)
        innerTableView.dataSource = self
        innerTableView.delegate = self
        innerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return innerTableView
    }()
    
    let itemArr = NSArray.init(objects: "网络框架")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(self.tableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (self.itemArr[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc : NetRequestExampleController = NetRequestExampleController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

