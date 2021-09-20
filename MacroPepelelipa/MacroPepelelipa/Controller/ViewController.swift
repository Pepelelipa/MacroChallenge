//
//  ViewController.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 16/09/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

internal protocol KeyboardShortcutDelegate: AnyObject {
    func commandN()
    func commandF()
    func commandB()
    func commandI()
    func commandU()
    func commandDelete()
    func commandShiftN()
}

extension KeyboardShortcutDelegate {
    func commandN() {}
    func commandF() {}
    func commandB() {}
    func commandI() {}
    func commandU() {}
    func commandDelete() {}
    func commandShiftN() {}
}

internal class ViewController: UIViewController {

    // MARK: - Keyboard shortcuts
    
    internal weak var keyboardShortcutDelegate: KeyboardShortcutDelegate?
    
    internal var newCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "N", modifierFlags: .command, propertyList: Notification.Name.didPressCommandN.rawValue)
    }()
    
    internal var newShiftCommand: UIKeyCommand = {
        return UIKeyCommand(title: "", action: #selector(triggerShortcut(_:)), input: "N", modifierFlags: [.command, .shift], propertyList: Notification.Name.didPressCommandShiftN.rawValue)
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
    
    @objc internal func triggerShortcut(_ command: UIKeyCommand) {
        guard let property = command.propertyList as? String else {
            return
        }
                
        switch Notification.Name(property) {
        case .didPressCommandN:
            keyboardShortcutDelegate?.commandN()
            
        case .didPressCommandF:
            keyboardShortcutDelegate?.commandF()

        case .didPressCommandB:
            keyboardShortcutDelegate?.commandB()

        case .didPressCommandI:
            keyboardShortcutDelegate?.commandI()

        case .didPressCommandU:
            keyboardShortcutDelegate?.commandU()

        case .didPressCommandDelete:
            keyboardShortcutDelegate?.commandDelete()

        case .didPressCommandShiftN:
            keyboardShortcutDelegate?.commandShiftN()
            
        default:
            break
        }
        
    }
}
