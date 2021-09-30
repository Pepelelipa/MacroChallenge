//
//  ViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 16/09/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

/**
 Default View Controller for the project.
 
 Handles keyboard shortcuts everywhere.
 */
internal class ViewController: UIViewController {

    // MARK: - Keyboard shortcuts
        
    /**
     __􀆔 + N__
    
     Handles operations related to creation of content.
     */
    internal var newCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "N", modifierFlags: .command, propertyList: Notification.Name.didPressCommandN.rawValue)
    }()
    
    /**
     __􀆔 + 􀆝 + N__
    
     Handles new window creation.
     */
    internal var newShiftCommand: UIKeyCommand = {
        return UIKeyCommand(title: "New window".localized(),
                            action: #selector(triggerShortcut(_:)), input: "N",
                            modifierFlags: [.command, .shift],
                            propertyList: Notification.Name.didPressCommandShiftN.rawValue)
    }()
    
    /**
     __􀆔 + F__
    
     Handles operations related to search of content.
     */
    internal var findCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "F", modifierFlags: .command, propertyList: Notification.Name.didPressCommandF.rawValue)
    }()
    
    /**
     __􀆔 + B__
    
     Handles operations related to font markup (bold).
     */
    internal var boldCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "B", modifierFlags: .command, propertyList: Notification.Name.didPressCommandB.rawValue)
    }()
    
    /**
     __􀆔 + I__
    
     Handles operations related to font markup (italic).
     */
    internal var italicCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "I", modifierFlags: .command, propertyList: Notification.Name.didPressCommandI.rawValue)
    }()
    
    /**
     __􀆔 + U__
    
     Handles operations related to font markup (underline).
     */
    internal var underlineCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "U", modifierFlags: .command, propertyList: Notification.Name.didPressCommandU.rawValue)
    }()
    
    /**
     __􀆔 + 􀆛__
    
     Handles operations related to deletion of content.
     */
    internal var deleteCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "\u{8}", modifierFlags: .command, propertyList: Notification.Name.didPressCommandDelete.rawValue)
    }()
        
    // MARK: - Overridables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// All view controllers should listen to all commands and choose to handle or not each one of them
        addKeyCommand(newCommand)
        addKeyCommand(newShiftCommand)
        addKeyCommand(findCommand)
        addKeyCommand(boldCommand)
        addKeyCommand(italicCommand)
        addKeyCommand(underlineCommand)
        addKeyCommand(deleteCommand)
    }
    
    // MARK: - Command action handling
    
    /**
     Handles shortcuts when fired.
     - Parameter command: The command that was fired. It's ```propertyList``` should containt the name of the notification to be handled.
     */
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
    
    /// Handles __􀆔 + N__ operations.
    func commandN() {
        NSLog(String(describing: self) + ": ⌘ + N")
    }
    
    /// Handles __􀆔 + F__ operations.
    func commandF() {
        NSLog(String(describing: self) + ": ⌘ + F")
    }
    
    /// Handles __􀆔 + B__ operations.
    func commandB() {
        NSLog(String(describing: self) + ": ⌘ + B")
    }
    
    /// Handles __􀆔 + I__ operations.
    func commandI() {
        NSLog(String(describing: self) + ": ⌘ + I")
    }
    
    /// Handles __􀆔 + U__ operations.
    func commandU() {
        NSLog(String(describing: self) + ": ⌘ + U")
    }
    
    /// Handles __􀆔 + 􀆛__ operations.
    func commandDelete() {
        NSLog(String(describing: self) + ": ⌘ + ⌫")
    }
    
    /// Handles __􀆔 + 􀆝 + N__ operations.
    func commandShiftN() {
        NSLog(String(describing: self) + ": ⌘ + ⇧ Shift + N")
        let activity = NSUserActivity(activityType: "panel")
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil)
    }
}
