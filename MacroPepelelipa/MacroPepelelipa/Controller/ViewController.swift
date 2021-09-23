//
//  ViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 16/09/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal class ViewController: UIViewController {

    // MARK: - Keyboard shortcuts
        
    internal var newCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "N", modifierFlags: .command, propertyList: Notification.Name.didPressCommandN.rawValue)
    }()
    
    internal var newShiftCommand: UIKeyCommand = {
        return UIKeyCommand(title: "New window".localized(),
                            action: #selector(triggerShortcut(_:)), input: "N",
                            modifierFlags: [.command, .shift],
                            propertyList: Notification.Name.didPressCommandShiftN.rawValue)
    }()
    
    internal var findCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "F", modifierFlags: .command, propertyList: Notification.Name.didPressCommandF.rawValue)
    }()
    
    internal var boldCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "B", modifierFlags: .command, propertyList: Notification.Name.didPressCommandB.rawValue)
    }()
    
    internal var italicCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "I", modifierFlags: .command, propertyList: Notification.Name.didPressCommandI.rawValue)
    }()
    
    internal var underlineCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "U", modifierFlags: .command, propertyList: Notification.Name.didPressCommandU.rawValue)
    }()
    
    internal var deleteCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "\u{8}", modifierFlags: .command, propertyList: Notification.Name.didPressCommandDelete.rawValue)
    }()
        
    // MARK: - Overridables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyCommand(newCommand)
        addKeyCommand(newShiftCommand)
        addKeyCommand(findCommand)
        addKeyCommand(boldCommand)
        addKeyCommand(italicCommand)
        addKeyCommand(underlineCommand)
        addKeyCommand(deleteCommand)
    }
    
    // MARK: - Command action handling
    
    @objc private func triggerShortcut(_ command: UIKeyCommand) {
        guard let property = command.propertyList as? String else {
            return
        }
                
        switch Notification.Name(property) {
        case .didPressCommandN:
            self.commandN()
            
        case .didPressCommandF:
            self.commandF()

        case .didPressCommandB:
            self.commandB()

        case .didPressCommandI:
            self.commandI()

        case .didPressCommandU:
            self.commandU()

        case .didPressCommandDelete:
            self.commandDelete()

        case .didPressCommandShiftN:
            self.commandShiftN()
            
        default:
            break
        }
    }
    
    func commandN() {
        NSLog(String(describing: self) + ": ⌘ + N")
    }
    
    func commandF() {
        NSLog(String(describing: self) + ": ⌘ + F")
    }
    
    func commandB() {
        NSLog(String(describing: self) + ": ⌘ + B")
    }
    
    func commandI() {
        NSLog(String(describing: self) + ": ⌘ + I")
    }
    
    func commandU() {
        NSLog(String(describing: self) + ": ⌘ + U")
    }
    
    func commandDelete() {
        NSLog(String(describing: self) + ": ⌘ + ⌫")
    }
    
    func commandShiftN() {
        NSLog(String(describing: self) + ": ⌘ + ⇧ Shift + N")
        let activity = NSUserActivity(activityType: "panel")
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil)
    }
}
