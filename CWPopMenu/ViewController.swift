//
//  ViewController.swift
//  CWPopMenu
//
//  Created by WANGCHAO on 08/02/2017.
//  Copyright © 2017 guokr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, cwPopupProtocal {

    @IBAction func leftTopAction(_ sender: UIButton) {
        let menu = CWPopMenu()
        menu.arrowHeight = 10
        menu.arrowWidth = 5
        menu.menuCorerRadius = 3.0
        menu.borderColor = UIColor.red
        menu.itemHeight = 30
        menu.itemSperatorColor = UIColor.green
        menu.menuWidth = 50
        menu.menuBgColor = UIColor.white
        menu.titles = ["待付款", "待收货", "待发货"]
        menu.delegate = self as? cwPopupProtocal
        menu.show(sender)
    }
    
    
    func getSelectedIndex(index:NSInteger) {
        print(index)
    }
    
    
    @IBAction func rightTopAction(_ sender: UIButton) {
        let menu = CWPopMenu()
        menu.arrowHeight = 10
        menu.arrowWidth = 5
        menu.menuCorerRadius = 3.0
        menu.borderColor = UIColor.black
        menu.itemHeight = 80
        menu.itemSperatorColor = UIColor.green
        menu.menuWidth = 300
        menu.menuBgColor = UIColor.white
        menu.borderHOffset = -35
        menu.titles = ["已提问", "已回答", "已取消", "已提问", "已回答", "已取消"]
        
        menu.show(sender)
    }
    
    @IBAction func leftBottomAction(_ sender: UIButton) {
        let menu = CWPopMenu()
        menu.arrowHeight = 10
        menu.arrowWidth = 5
        menu.menuCorerRadius = 3.0
        menu.borderColor = UIColor.darkGray
        menu.itemHeight = 45
        menu.itemSperatorColor = UIColor.red
        menu.menuWidth = 92
        menu.menuBgColor = UIColor.orange
        menu.itemTitleNormalColor = UIColor.black
        menu.itemTitleSelectedColor = UIColor.white
        menu.titles = ["待付款", "待收货", "待发货"]
        menu.selectedIndex = 1
        
        menu.show(sender)
    }
    
    @IBAction func rightBottomAction(_ sender: UIButton) {
        let menu = CWPopMenu()
        menu.arrowHeight = 10
        menu.arrowWidth = 5
        menu.menuCorerRadius = 3.0
        menu.borderColor = UIColor.red
        menu.itemHeight = 30
        menu.itemSperatorColor = UIColor.green
        menu.menuWidth = 50
        menu.menuBgColor = UIColor.yellow
        menu.titles = ["已提问", "已回答", "已取消", "已提问", "已回答", "已取消"]
       
       
        
        menu.show(sender)
    }
    
    @IBAction func centerAction(_ sender: UIButton) {
        let menu = CWPopMenu()
        menu.arrowHeight = 10
        menu.arrowWidth = 5
        menu.menuCorerRadius = 3.0
        menu.borderColor = UIColor.red
        menu.itemHeight = 30
        menu.itemSperatorColor = UIColor.green
        menu.menuWidth = 50
        menu.menuBgColor = UIColor.white
        menu.titles = ["已提问", "已回答", "已取消", "已提问", "已回答", "已取消"]
        
        menu.show(sender)
    }
    
}

