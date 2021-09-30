//
//  NotificationName+Extension.swift
//  MacroPepelelipa
//
//  Created by Lia Kassardjian on 14/09/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var didPressCommandN: Notification.Name {
        return .init(rawValue: "KeyCommand.didPressCommandN")
    }
    
    static var didPressCommandShiftN: Notification.Name {
        return .init(rawValue: "KeyCommand.didPressCommandShiftN")
    }
    
    static var didPressCommandF: Notification.Name {
        return .init(rawValue: "KeyCommand.didPressCommandF")
    }
    
    static var didPressCommandDelete: Notification.Name {
        return .init(rawValue: "KeyCommand.didPressCommandDelete")
    }
    
    static var didPressCommandB: Notification.Name {
        return .init(rawValue: "KeyCommand.didPressCommandB")
    }
    
    static var didPressCommandI: Notification.Name {
        return .init(rawValue: "KeyCommand.didPressCommandI")
    }
    
    static var didPressCommandU: Notification.Name {
        return .init(rawValue: "KeyCommand.didPressCommandU")
    }
}
