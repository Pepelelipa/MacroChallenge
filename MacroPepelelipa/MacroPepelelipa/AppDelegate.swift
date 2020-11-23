//
//  AppDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import MarkdownText
import Database
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let openSans = UIFont.openSans {
            Fonts.availableFonts.append(openSans)
        }
        if let merriweather = UIFont.merriweather {
            Fonts.availableFonts.append(merriweather)
            Fonts.defaultTextFont = merriweather
        }
        if let dancingScript = UIFont.dancingScript {
            Fonts.availableFonts.append(dancingScript)
        }
        
        let errorHandling: (Error?) -> Void = {
            if ($0 as? CKError)?.errorCode != 15, let error = $0 as? CKError {
                ConflictHandlerObject().errDidOccur(err: error)
            }
        }

        CKSubscriptionController.createWorkspaceSubscription(errorHandler: errorHandling)
        CKSubscriptionController.createNotebookSubscription(errorHandler: errorHandling)
        CKSubscriptionController.createNoteSubscription(errorHandler: errorHandling)
        CKSubscriptionController.createTextBoxSubscription(errorHandler: errorHandling)
        CKSubscriptionController.createImageBoxSubscription(errorHandler: errorHandling)
        application.registerForRemoteNotifications()
        
        DataManager.shared().conflictHandler = ConflictHandlerObject()
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    // MARK: Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) as? CKQueryNotification {
            do {
                try DataManager.shared().handleNotification(notification)
                completionHandler(.newData)
            } catch {
                completionHandler(.failed)
            }
        } else {
            completionHandler(.noData)
        }
    }
    
    // MARK: - Menus
    
    var menuController: MenuController?
    
    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == .main {
            menuController = MenuController(with: builder)
        }
    }
}

struct AppUtility {
    static func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func setOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {

        self.setOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
