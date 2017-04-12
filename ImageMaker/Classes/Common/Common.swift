//
//  Common.swift
//  ImageMaker
//
//  Created by PhuongVNC on 10/6/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

struct DateFormat {
    static let Date = "dd/MM/yyyy"
    static let DateTime12H = "dd/MM/yyyy HH:mm:ss"
}

class Common {
    static let dateFormatter = DateFormatter()
    
    class func convertSizetoString(size:Double) -> String {
        if size <= pow(2,10) {
            return "\(Int(size)) bytes"
        } else  if size <= pow(2,20) {
            let number = size/pow(2,10)
            return "\(Int(number)) KB"
        } else if size <=  pow(2,30) {
            let number = size/pow(2,20)
            return "\(Int(number)) MB"
        } else if size <=  pow(2,40) {
            let number = size/pow(2,30)
            return "\(Int(number)) TB"
        } else {
            return String(size)
        }
    }
    
}

extension DateFormatter {
    class func fromFormat(format:String) -> DateFormatter {
        let dateFormatter = Common.dateFormatter
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}


