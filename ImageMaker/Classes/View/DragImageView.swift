//
//  DragImageView.swift
//  ImageMaker
//
//  Created by framgia on 3/9/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Cocoa

enum ErrorType {
    case type
    case size
}

protocol DragImageViewDelegate: class {
    func dragImageView(imageView: DragImageView, updateFilePath path: String)
    func dragImageView(imageView: DragImageView, failType type:ErrorType)
}


class DragImageView: NSImageView {

    weak var delegate: DragImageViewDelegate?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let rightColor = NSColor(red: 242 / 255.0, green: 109 / 255.0, blue: 125 / 255.0, alpha: 1.0)
        self.layer?.borderColor = rightColor.cgColor
        self.layer?.borderWidth = 2.0
        self.layer?.cornerRadius = 5
        self.layer?.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // Declare and register an array of accepted types
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType, NSPasteboardTypeTIFF])
    }

    let fileTypes = ["jpg", "jpeg", "bmp", "png", "gif"]
    var fileTypeIsOk = false
    var droppedFilePath: String?
    var size: CGSize = CGSize.zero


    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {

        NSLog(("Drag Enterd"))
        if checkExtension(drag: sender) {
            if checkSize(drag: sender) {
                fileTypeIsOk = true
                return .copy
            } else {
                delegate?.dragImageView(imageView: self, failType: .size)
                fileTypeIsOk = false
                return []
            }

        } else {
            delegate?.dragImageView(imageView: self, failType: .type)
            fileTypeIsOk = false
            return []
        }
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        NSLog(("draggingUpdated"))
        if fileTypeIsOk {
            return .copy
        } else {
            return []
        }
    }

    override func draggingEnded(_ sender: NSDraggingInfo?) {
        NSLog(("draggingEnded"))
        if let filePath = droppedFilePath {
            delegate?.dragImageView(imageView: self, updateFilePath: filePath)
        }
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        NSLog(("performDragOperation"))
        if let board = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let imagePath = board[0] as? String {
            droppedFilePath = imagePath
            return true
        }
        return false
    }

    func checkSize(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String {
            if let image = NSImage(contentsOfFile: path), image.size.width <= size.width && image.size.height <= size.height {
                return true
            } else {
                return false
            }
        }
        return false
    }

    func checkExtension(drag: NSDraggingInfo) -> Bool {
        NSLog(("checkExtension"))
        if let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String {
            let url = NSURL(fileURLWithPath: path)
            if let fileExtension = url.pathExtension?.lowercased() {
                return fileTypes.contains(fileExtension)
            }
        }
        return false
    }
}
