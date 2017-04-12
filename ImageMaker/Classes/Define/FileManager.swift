//
//  FileManager.swift
//  CardBook
//


import Cocoa

class ImageManager: NSObject {
    
    class var shareInstance: ImageManager {
        struct Singleton {
            static let instance = ImageManager()
        }
        return Singleton.instance
    }
    func getPathDirectory(typeDirectory: FileManager.SearchPathDirectory) -> String{
        return NSSearchPathForDirectoriesInDomains(typeDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    }
    
    func getPathFile(name: String, typeDirectory: FileManager.SearchPathDirectory) -> String! {
        let pathFile = getPathDirectory(typeDirectory: typeDirectory)
        let path = pathFile.appending(name)
        return path
    }
    
    func checkFileExist(name: String, typeDirectory: FileManager.SearchPathDirectory) -> Bool {
        let path = getPathFile(name: name, typeDirectory: typeDirectory)
        if FileManager.default.fileExists(atPath: path!) {
            return true
        } else {
            return false
        }
    }
    
    func deleteFile(name: String, typeDirectory: FileManager.SearchPathDirectory) -> Bool {
        let path = getPathFile(name: name, typeDirectory: typeDirectory)
        if checkFileExist(name: name, typeDirectory: typeDirectory) {
            do {
                try FileManager.default.removeItem(atPath: path!)
            } catch _ {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    func saveFile(file: NSImage, name: String, typeDirectory: FileManager.SearchPathDirectory) -> Bool {
        let path = getPathFile(name: name, typeDirectory: typeDirectory)
        let data = convertImageToPNG(image: file)
        if checkFileExist(name: name, typeDirectory: typeDirectory) {
            if deleteFile(name: name, typeDirectory: typeDirectory) {
                FileManager.default.createFile(atPath: path!, contents: data, attributes: nil)
                return checkFileExist(name: name, typeDirectory: typeDirectory)
            } else {
                return false
            }
        } else {
            FileManager.default.createFile(atPath: path!, contents: data, attributes: nil)
            return checkFileExist(name: name, typeDirectory: typeDirectory)
        }
    }
    
    func loadFile(name: String, typeDirectory: FileManager.SearchPathDirectory) -> NSImage? {
        if checkFileExist(name: name, typeDirectory: typeDirectory) {
            let url = URL(fileURLWithPath: getPathFile(name: name, typeDirectory: typeDirectory))
            do {
               let data = try Data(contentsOf: url)
                return NSImage(data: data)
            } catch _ {
                return nil
            }
        } else {
            return nil
        }
        
 
    }

    func convertImageToPNG(image:NSImage) -> Data? {
        if var imageData = image.tiffRepresentation {
            let imageBitmap = NSBitmapImageRep(data: imageData)
            let imageDictionary = ["NSImageProgressive":true]
            imageData = imageBitmap!.representation(using: .PNG, properties: imageDictionary)!
            return imageData
        }
        return nil
    }
    
    func checkImagePNG(url:URL) -> Bool {
        let fileExtension = url.pathExtension
        if fileExtension.lowercased() == "png" {
            return true
        } else {
            return false
        }
    }
    
    func checkImageJPG(url:URL) -> Bool {
        let fileExtension = url.pathExtension
        if fileExtension.lowercased() == "jpg" {
            return true
        } else {
            return false
        }
    }
    
    func checkImageJPEG(url:URL) -> Bool {
        let fileExtension = url.pathExtension
        if fileExtension.lowercased() == "jpeg" {
            return true
        } else {
            return false
        }
    }

}
