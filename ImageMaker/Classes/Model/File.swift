//
//  File.swift
//  ImageMaker
//
//  Created by PhuongVNC on 10/6/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

enum Status:String {
    case New
    case Inprogress
    case Finish
    case Error
}

class File {
    var name  = ""
    var url = ""
    var date = ""
    var size = 0
    var status = Status.New
    
    init(name:String,url:String,date:String,size:Int) {
        self.name = name
        self.url = url
        self.date = date
        self.size = size
    }
    
}
