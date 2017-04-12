//
//  DateTime.swift
//  ImageMaker
//
//  Created by PhuongVNC on 10/6/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation


extension Date {
    
    func toString(format:String,localized:Bool) -> String {
        let fmt = DateFormatter.fromFormat(format: format)
        fmt.timeZone = localized ? NSTimeZone.local : NSTimeZone.utcTimeZone()
        return fmt.string(from: self)
    }
    
    public init(str: String, format: String, localized: Bool) {
        let fmt = DateFormatter.fromFormat(format: format)
        fmt.timeZone = localized ? NSTimeZone.local : NSTimeZone.utcTimeZone()
        if let date = fmt.date(from: str) {
            self.init(timeInterval: 0, since: date)
        } else {
            self.init(timeInterval: 0, since: Date())
        }
    }
    
}


extension String {
    func toDate(format:String,localized:Bool) -> Date {
        return Date(str: self, format: format, localized: localized)
    }
}

extension NSTimeZone {
    public static func utcTimeZone() -> TimeZone {
        return TimeZone(abbreviation: "UTC")!
    }
}
