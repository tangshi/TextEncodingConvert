//
//  ConvertView.swift
//  TextEncodingConvert
//
//  Created by tangshi on 15/8/8.
//  Copyright © 2015年 tangshi. All rights reserved.
//

import Cocoa

enum Encoding {
    case GBK
    case UTF8
}

class ConvertView: NSView {

    var sourceEncoding = Encoding.GBK
    
    let gbk_encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
    
    var controller: ViewController?
    
    var convertResult = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSFilenamesPboardType])
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    
    //MARK:- NSDraggingDestination methods
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.Every
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        
        let pBoard = sender.draggingPasteboard()
        
        if let arr = pBoard.propertyListForType(NSFilenamesPboardType) as? NSArray {
            
            convertResult = ""
            
            let converted_size = convertAll(arr as! [String])
            
            var resultHead = ""
            if sourceEncoding == .GBK {
                resultHead = "原编码: GBK -> 目标编码: UTF-8"
            }
            else {
                resultHead = "原编码: UTF-8 -> 目标编码: GBK"
            }
            resultHead = "\(resultHead) \n \n 本次共转换\(converted_size)个文件 : \n\n"

            controller?.convertResultView.string = resultHead + convertResult
            
            return true
        }
        else {
            return false
        }
    }

    
    func convertAll(path_arr: [String]) -> Int {
        
        var size = 0
        
        for path in path_arr {
            
            var isDir = ObjCBool(false)
            NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
            
            if isDir.boolValue {
                do {
                    var contents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
                    for i in 0..<contents.count {
                        contents[i] = path + "/" + contents[i]
                    }
                    size += convertAll(contents)
                }
                catch {
                    Swift.print("fail to get contents of directory: \(path)", appendNewline: true)
                }
            }
            else {
                if convertEncoding(path) == true {
                    convertResult = convertResult + "  \(path)\n"
                    size++
                }
            }
        }
        
        return size
    }
    
    func convertEncoding(path: String) -> Bool {
        
        var result = false
        let source_enc = (sourceEncoding == .GBK) ? gbk_encoding : NSUTF8StringEncoding
        let target_enc = (sourceEncoding == .GBK) ? NSUTF8StringEncoding : gbk_encoding
        
        do{
            // 读取原文件， 编码为 source_enc
            let text = try NSString(contentsOfFile: path, encoding: source_enc)
            
            // 将字符串 text 写入文件，指定编码为 target_enc
            do {
                try text.writeToFile(path, atomically: true, encoding: target_enc)
                result = true
            }
            catch {
                Swift.print("write file error", appendNewline: true)
            }
        }
        catch {
            Swift.print("read file error", appendNewline: true)
        }
        
        return result
    }
}


