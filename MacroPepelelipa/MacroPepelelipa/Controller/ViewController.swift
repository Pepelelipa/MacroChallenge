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

internal class ViewController: UIViewController {

    // MARK: - Keyboard shortcuts
    
    internal weak var keyboardShortcutDelegate: KeyboardShortcutDelegate?
        
    // MARK: - Overridables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
    }
    
    // MARK: - Notification handling
    
    private func addObservers() {
        for name in Notification.Name.keyboardShortcuts {
            NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: name, object: nil)
        }
    }

    @objc private func notificationHandler(_ key: String) {
        let notification = Notification.Name(key)
        
        switch notification {
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
    
    internal func triggerShortcut(_ command: UIKeyCommand) {
        guard let commandName = command.propertyList as? String else {
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name(commandName), object: nil)
    }
}
