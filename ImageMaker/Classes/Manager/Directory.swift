//
//  Directory.swift
//  ImageMaker
//
//  Created by PhuongVNC on 10/6/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation

class Directory {
    class func fetchImageFile(url:String) -> [File] {
        let fileManager = FileManager.default
        var files = [File]()
        if let enumerator = fileManager.enumerator(atPath:url) {
            for item in enumerator {
            let urlString = "\(url)/\(item)"
            let path  = URL(fileURLWithPath: urlString)
                if ImageManager.shareInstance.checkImagePNG(url: path) || ImageManager.shareInstance.checkImageJPG(url: path) || ImageManager.shareInstance.checkImageJPEG(url: path) {
                    if let file  = getFile(url: urlString) {
                        files.append(file)
                    }
                }
            
            }
            return files
        }
       
        return files
    }
    
    class func getFile(url:String) -> File? {
        let fileURL = URL(fileURLWithPath: url)
        do {
            let set:Set<URLResourceKey> = NSSet(array: [URLResourceKey.nameKey,URLResourceKey.contentModificationDateKey,URLResourceKey.fileSizeKey]) as! Set<URLResourceKey>
            let resource = try fileURL.resourceValues(forKeys: set)
            let file  = File(name: resource.name!,url:url, date: resource.contentModificationDate!.toString(format: DateFormat.DateTime12H, localized: true), size: resource.fileSize!)
            return file
        } catch _ {
            return nil
        }
    }
}
