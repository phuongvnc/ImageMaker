//
//  RenderImageViewController.swift
//  ImageMaker
//
//  Created by PhuongVNC on 10/6/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import Cocoa

private enum ScaleType:String {
    case all = "All"
    case width = "Width"
    case height = "Height"

}

class IntegerFormatter: NumberFormatter {

    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        // Allow blank value
        if partialString.numberOfCharacters() == 0  {
            return true
        }

        // Validate string if it's an int
        if partialString.isInt() {
            return true
        } else {
            NSBeep()
            return false
        }
    }
}

extension String {

    func isInt() -> Bool {

        if let intValue = Int(self) {
            if intValue >= 0 {
                return true
            }
        }

        return false
    }

    func numberOfCharacters() -> Int {
        return self.characters.count
    }
}

class RenderImageViewController: NSViewController {
    @IBOutlet private weak var outputTextField:NSTextField!
    @IBOutlet private weak var inputTextField:NSTextField!
    @IBOutlet private weak var fixPopUp:NSPopUpButton!
    @IBOutlet private weak var widthTextField:NSTextField!
    @IBOutlet private weak var heightTextField:NSTextField!
    @IBOutlet private weak var fileTableView:NSTableView!
    private var scaleType: ScaleType = .all {
        didSet {
            switch scaleType {
            case .all:
                widthTextField.isEnabled = true
                heightTextField.isEnabled = true
                widthTextField.becomeFirstResponder()
            case .width:
                widthTextField.isEnabled = true
                heightTextField.isEnabled = false
                heightTextField.stringValue = ""
                widthTextField.becomeFirstResponder()
            case .height:
                widthTextField.isEnabled = false
                heightTextField.isEnabled = true
                widthTextField.stringValue = ""
                heightTextField.becomeFirstResponder()

            }
        }
    }
    
    private var isOutput = false
    private var isInput = false
    private var outputString = ""
    private var inputString = ""
    
    fileprivate var files = [File]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fileTableView.delegate = self
        fileTableView.dataSource = self
        widthTextField.formatter = IntegerFormatter()
        heightTextField.formatter = IntegerFormatter()

    }

    //MARK: - Action
    @IBAction private func didSelectInputFolder(sender:NSButton) {
        let window = NSApplication.shared().mainWindow
        let  panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.message = "Import input direction"
        panel.beginSheetModal(for: window!) { (action) in
            if action == NSFileHandlingPanelOKButton {
                if let url = panel.urls.first {
                    self.files.removeAll()
                    self.inputTextField.stringValue = url.path
                    self.inputString = url.path
                    self.isInput = true
                    self.files = Directory.fetchImageFile(url: self.inputString)
                    self.fileTableView.reloadData()
                }
            }
        }
    }

    @IBAction private func didSelectOutputFolder(sender:NSButton) {
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
                    self.outputString = url.path
                    self.isOutput = true
                }
            }
        }
    }

    @IBAction private func didSelectScaleType(sender:NSPopUpButton) {
        if let selectedItem = sender.selectedItem, let type = ScaleType(rawValue: selectedItem.title) {
            fixPopUp.stringValue = selectedItem.title
            scaleType = type
        }
    }


    @IBAction private func didSelecteGenerate(sender:NSButton) {
        if isInput && isOutput {
            if let width = Float(widthTextField.stringValue),let height = Float(heightTextField.stringValue), let scaleType = fixPopUp.selectedItem {
                if width <= 1024 || height <= 1024 {
                    for file in files {

                        file.status = Status.Inprogress
                        fileTableView.reloadData()

                        var tempWidth = CGFloat(width)
                        var tempHeight = CGFloat(height)
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: file.url))
                            let image = NSImage(data: data)
                            if scaleType.title == ScaleType.width.rawValue {
                                tempHeight = (image!.size.height * tempWidth)/image!.size.width
                            } else if scaleType.title == ScaleType.height.rawValue {
                                tempWidth = (image!.size.width * tempHeight)/image!.size.height
                            }

                            if tempWidth > 0 && tempHeight > 0 {
                                let resizeImage = image?.resize(size: CGSize(width:tempWidth,height:tempHeight))
                                let path = "\(self.outputString)/\(file.name)"
                                file.status =  resizeImage!.save(path: path) ? Status.Finish : Status.Error
                                OperationQueue.main.addOperation({
                                    self.fileTableView.reloadData()
                                })
                            }

                            self.checkFinishAllFile()
                        } catch {

                        }
                    }
                } else {
                    showAlertWithMessage(message: "Width or Height greater 1024!",completion: nil)
                }
            } else {
                showAlertWithMessage(message: "Width or Height is blank!",completion: nil)
            }
        } else {
            showAlertWithMessage(message: "Input Direction or Output Direction is blank!",completion: nil)
        }
    }

    private func checkFinishAllFile() {
        let count = files.filter { (file) -> Bool in
            return file.status == Status.Finish
            }.count
        if count == files.count {
            showAlertWithMessage(message:  "Process \(count) files is successfuly!", completion: { (result) in
                NSWorkspace.shared().selectFile(nil, inFileViewerRootedAtPath:self.outputString)
            })
        }
    }

    func showAlertWithMessage(message:String,completion:((NSModalResponse) -> Void)?) {
        let alertView = NSAlert()
        alertView.delegate = self
        alertView.messageText = message
        alertView.addButton(withTitle: "OK")
        completion?(alertView.runModal())
    }
}

// MARK: - NSTableViewDataSource
extension RenderImageViewController:NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return files.count
    }

    @objc(tableView:viewForTableColumn:row:) func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier: String = "NameIdentify"

        let item  = files[row]
        var string = ""
        if tableColumn == tableView.tableColumns[0] {
            string = item.name
        } else if tableColumn == tableView.tableColumns[1] {
            string = item.date
        } else if tableColumn == tableView.tableColumns[2] {
            string = Common.convertSizetoString(size: Double(item.size))
        } else {
            string = item.status.rawValue
        }

        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = string
            cell.textField?.alignment = NSTextAlignment.center
            cell.imageView?.image = nil
            return cell
        }
        return nil
    }
}


// MARK: - NSTableViewDelegate
extension RenderImageViewController:NSTableViewDelegate {

}

extension RenderImageViewController:NSAlertDelegate {

}

extension RenderImageViewController: NSTextFieldDelegate {
    
}


