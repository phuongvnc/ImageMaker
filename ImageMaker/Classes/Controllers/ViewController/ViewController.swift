//
//  ViewController.swift
//  ImageMaker
//
//  Created by PhuongVNC on 10/4/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet fileprivate weak var photoImageView:DragImageView!
    @IBOutlet fileprivate weak var iMessageImageView:DragImageView!
    @IBOutlet private weak var outputTextField:NSTextField!
    @IBOutlet private weak var widthTextField:NSTextField!
    @IBOutlet private weak var heightTextField:NSTextField!
    @IBOutlet private weak var appIconLabel: NSTextField!
    @IBOutlet private weak var iMessageLabel: NSTextField!
    private var hasNewOutputFolder = false
    fileprivate var hasImage = false {
        didSet {
            if isViewLoaded {
                appIconLabel.isHidden = hasImage
            }
        }
    }
    fileprivate var hasiMessageImage = false {
        didSet {
            if isViewLoaded {
                iMessageLabel.isHidden = hasiMessageImage
            }
        }
    }
    private var directionOutputString = ""
    private var nameOutputString = "AppIcon"


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpUI()
    }

    override var representedObject: Any? {
        didSet {

        }
    }

    func setUpData() {
        let documentPath = ImageManager.shareInstance.getPathDirectory(typeDirectory: .documentDirectory)
        directionOutputString = "\(documentPath)/\(nameOutputString)"
        outputTextField.stringValue = directionOutputString
    }

    func setUpUI() {
        photoImageView.delegate = self
        iMessageImageView.delegate = self
        photoImageView.size = CGSize(width: 1024, height: 1024)
        iMessageImageView.size = CGSize(width: 1024, height: 768)

    }

    // MARK: - Private

    func showAlertWithMessage(message:String) {
        let alertView = NSAlert()
        alertView.messageText = message
        alertView.addButton(withTitle: "OK")
        alertView.runModal()
    }


    // MARK: - Action
    @IBAction private func didSelectAppIcon(sender:NSButton) {

        let names = ["iphone_29x29.png",
                     "iphone_29x29_2x.png",
                     "iphone_29x29_3x.png",
                     "iphone_40x40.png",
                     "iphone_40x40_2x.png",
                     "iphone_40x40_3x.png",
                     "iphone_57x57.png",
                     "iphone_57x57_2x.png",
                     "iphone_60x60.png",
                     "iphone_60x60_2x.png",
                     "iphone_60x60_3x.png",
                     "ipad_29x29.png",
                     "ipad_29x29_2x.png",
                     "ipad_40x40.png",
                     "ipad_40x40_2x.png",
                     "ipad_50x50.png",
                     "ipad_50x50_2x.png",
                     "ipad_72x72.png",
                     "ipad_72x72_2x.png",
                     "ipad_76x76.png",
                     "ipad_76x76_2x.png",
                     "ipad_83,5x83,5_2x.png",
                     "car_60x60.png",
                     "car_60x60_2x.png",
                     "car_60x60_3x.png",
                     "watch_38_notificationCenter_24x24_2x.png",
                     "watch_42_notificationCenter_27,5x27,5_2x.png",
                     "watch_companionSettings_29x29.png",
                     "watch_companionSettings_29x29_2x.png",
                     "watch_companionSettings_29x29_3x.png",
                     "watch_38_appLauncher_40x40_2x.png",
                     "watch_42_longLook_44x44_2x.png",
                     "watch_38_quickLook_86x86_2x.png",
                     "watch_42_quickLook_98x98_2x.png"]

        let size = [29,
                    58,
                    87,
                    40,
                    80,
                    120,
                    57,
                    114,
                    60,
                    120,
                    180,
                    29,
                    58,
                    40,
                    80,
                    50,
                    100,
                    72,
                    144,
                    76,
                    152,
                    167,
                    60,
                    120,
                    180,
                    48,
                    55,
                    29,
                    58,
                    87,
                    80,
                    88,
                    172,
                    196]
        if !hasImage {
            showAlertWithMessage(message: "Please selecte image!")
            return
        }

        if !hasNewOutputFolder {
            if !FileManager.default.fileExists(atPath: directionOutputString) {
                do {
                    try  FileManager.default.createDirectory(atPath: directionOutputString, withIntermediateDirectories: false, attributes: nil)
                } catch _ {
                    showAlertWithMessage(message: "App can't create output folder")
                }

            }
        }

        var count = 0
        for (index,name) in names.enumerated() {
            let resizeImage = photoImageView.image?.resize(size:CGSize(width:size[index], height: size[index]))
            let imagePath = "\(directionOutputString)/\(name)"
            count += resizeImage!.save(path: imagePath) ? 1 : 0
        }

        if count == names.count {
            showAlertWithMessage(message: "Icon create success!")
        } else {
            showAlertWithMessage(message: "Icon create fail!")
        }

    }

    @IBAction private func didSelectAppIconiMessage(sender:NSButton) {
        let names = ["iphone_29x29_2x.png",
                     "iphone_29x29_3x.png",
                     "messages_60x45_2x.png",
                     "messages_60x45_3x.png",
                     "ipad_29x29_2x.png",
                     "messages_ipad_67x50_2x.png",
                     "messages_ipad__pro_74x55_2x.png",
                     "messages_27x20_2x.png",
                     "messages_27x20_3x.png",
                     "messages_32x24_2x.png",
                     "messages_32x24_3x.png",
                     "messages_appstore_1024x768_1x.png"]

        let size:[(width:Int,height:Int)] = [(58,58),(87,87),(120,90),(180,135),(58,58),(134,100),(148,110),(54,40),(81,60),(64,48),(96,72),(1024,768)]


        if !hasiMessageImage {
            showAlertWithMessage(message: "Please selecte image!")
            return
        }

        if !hasNewOutputFolder {
            if !FileManager.default.fileExists(atPath: directionOutputString) {
                do {
                    try  FileManager.default.createDirectory(atPath: directionOutputString, withIntermediateDirectories: false, attributes: nil)
                } catch _ {
                    showAlertWithMessage(message: "App can't create output folder")
                }

            }
        }

        var count = 0
        for (index,name) in names.enumerated() {
            if size[index].width == size[index].height {
                let resizeImage = iMessageImageView.image?.resize(size:CGSize(width:size[index].width, height: size[index].height))
                let imagePath = "\(directionOutputString)/\(name)"
                count += resizeImage!.save(path: imagePath) ? 1 : 0
            } else {
                let resizeImage = iMessageImageView.image?.resize(size:CGSize(width:size[index].width, height: size[index].height))
                let imagePath = "\(directionOutputString)/\(name)"
                count += resizeImage!.save(path: imagePath) ? 1 : 0
            }

        }




        if count == names.count {
            showAlertWithMessage(message: "Icon create success!")
        } else {
            showAlertWithMessage(message: "Icon create fail!")
        }

    }

    @IBAction private func didSelectChooseOutput(sender:NSButton) {

        let window = NSApplication.shared().mainWindow
        let  panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.message = "Import output direction"
        panel.beginSheetModal(for: window!) { (action) in
            if action == NSFileHandlingPanelOKButton {
                if let url = panel.urls.first {
                    self.outputTextField.stringValue = url.path
                    self.directionOutputString = url.path
                    self.hasNewOutputFolder = true
                }
            }
        }
    }

    @IBAction private func didSelectGenerateCustomSize(sender:NSButton) {
        if !hasImage {
            showAlertWithMessage(message: "Please selecte image!")
            return
        }

        if !hasNewOutputFolder {
            if !FileManager.default.fileExists(atPath: directionOutputString) {
                do {
                    try  FileManager.default.createDirectory(atPath: directionOutputString, withIntermediateDirectories: false, attributes: nil)
                } catch _ {
                    showAlertWithMessage(message: "App can't create output folder")
                }

            }
        }
        let width = Double(widthTextField.stringValue)!
        let height = Double(heightTextField.stringValue)!

        let resizeImage = photoImageView.image?.resize(size:CGSize(width:width, height: height))
        let imagePath = "\(directionOutputString)/appIcon_\(Int(width)))_\(Int(height)).png"
        if resizeImage!.save(path: imagePath) {
            showAlertWithMessage(message: "Icon create success!")
        } else {
            showAlertWithMessage(message: "Icon create fail!")
        }
    }

    @IBAction private func didSelectClear(sender:NSButton) {
        hasImage = false
        photoImageView.image = nil

    }

    @IBAction private func didSelectSelectedImage(sender:NSButton) {
        let window = NSApplication.shared().mainWindow

        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "Please import a image iMessage!"

        panel.beginSheetModal(for: window!) { (action) in
            if action == NSFileHandlingPanelOKButton {
                if let url = panel.urls.first , ImageManager.shareInstance.checkImagePNG(url: url) == true {
                    let image = NSImage(contentsOf: url)
                    if let image = image {
                        if image.size.width == 1024 && image.size.height == 1024 {
                            self.photoImageView.image = image
                            self.hasImage = true
                        } else {
                            self.showAlertWithMessage(message: "Please choose file with size 1024 x 1024!")
                        }
                    } else {
                        self.showAlertWithMessage(message: "Please choose file with PNG format!")
                    }
                } else {
                    self.showAlertWithMessage(message: "Please choose file with PNG format !")
                }
            }
        }
    }

    @IBAction private func didSelectCleariMessage(sender:NSButton) {
        hasImage = false
        iMessageImageView.image = nil

    }

    @IBAction private func didSelectSelectedImageiMessage(sender:NSButton) {
        let window = NSApplication.shared().mainWindow

        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "Please import a image!"

        panel.beginSheetModal(for: window!) { (action) in
            if action == NSFileHandlingPanelOKButton {
                if let url = panel.urls.first , ImageManager.shareInstance.checkImagePNG(url: url) == true {
                    let image = NSImage(contentsOf: url)
                    if let image = image {
                        if image.size.width == 1024 && image.size.height == 768 {
                            self.iMessageImageView.image = image
                            self.hasiMessageImage = true
                        } else {
                            self.showAlertWithMessage(message: "Please choose file with size 1024 x 768")
                        }
                    } else {
                        self.showAlertWithMessage(message: "Please choose file with PNG format!")
                    }
                } else {
                    self.showAlertWithMessage(message: "Please choose file with PNG format !")
                }
            }
        }
    }

}

extension NSImage {
    func resize(size:CGSize) -> NSImage? {
        let tempImage = self
        if  tempImage.isValid {
            let resizeImage  = NSImage(size: size)
            resizeImage.lockFocus()
            tempImage.size = size
            NSGraphicsContext.current()?.imageInterpolation = NSImageInterpolation.high
            tempImage.draw(at: NSZeroPoint, from:CGRect(x:0,y:0,width:size.width,height:size.height), operation: NSCompositeCopy, fraction: 1)
            resizeImage.unlockFocus()
            return resizeImage
        }
        return nil
    }

    func save(path:String) -> Bool {
        let data = ImageManager.shareInstance.convertImageToPNG(image: self)
        do {
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
            return true
        } catch _ {
            return false
        }
    }
}

extension ViewController: DragImageViewDelegate {
     func dragImageView(imageView: DragImageView, failType type: ErrorType) {
        if imageView == photoImageView {
            self.showAlertWithMessage(message: "Please choose file with size 1024 x 1024!")
        } else if imageView == iMessageImageView {
            self.showAlertWithMessage(message: "Please choose file with size 1024 x 768")
        }

    }

    func dragImageView(imageView: DragImageView, updateFilePath path: String) {
        if imageView == photoImageView {
            hasImage = true
        } else if imageView == iMessageImageView {
            hasiMessageImage = true
        }
    }
}
