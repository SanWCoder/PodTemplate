//
//  ViewController.swift
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // MARK: - 壳工程测试代码

        /// 壳工程测试代码
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        btn.center = view.center
        btn.backgroundColor = .red
        btn.setTitle("测试", for: .normal)
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        view.addSubview(btn)

    }
    
    @objc func btnClick(sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

