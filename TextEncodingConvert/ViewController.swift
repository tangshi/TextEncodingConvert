//
//  ViewController.swift
//  TextEncodingConvert
//
//  Created by tangshi on 15/8/8.
//  Copyright © 2015年 tangshi. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

    @IBOutlet weak var convertView: ConvertView!
  
    @IBOutlet var convertResultView: NSTextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        convertView.controller = self
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var leftLabel: NSTextFieldCell!
    
    @IBOutlet weak var rightLabel: NSTextFieldCell!
    
    @IBAction func switchEncoding(sender: NSButton) {
        if convertView.sourceEncoding == .GBK {
            convertView.sourceEncoding = .UTF8
            leftLabel.title = "原编码：UTF-8"
            rightLabel.title = "目标编码：GBK"
            print("utf => gbk", terminator: "\n")
        }
        else {
            convertView.sourceEncoding = .GBK
            leftLabel.title = "原编码：GBK"
            rightLabel.title = "目标编码：UTF-8"
            print("gbk => utf", terminator: "\n")
        }
    }
    
}

