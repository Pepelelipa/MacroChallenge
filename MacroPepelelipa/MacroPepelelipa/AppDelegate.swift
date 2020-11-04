//
//  AppDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import CoreSpotlight
import Database

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
    
    //TODO
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == CSSearchableItemActionType {
            guard let confirmedUserInfo = userActivity.userInfo,
                let uniqueIdentifier = confirmedUserInfo[CSSearchableItemActivityIdentifier] as? String else {
                    return false
            }
            
            do {
                
                let workspace = try DataManager.shared().fetchWorkspace(identifier: uniqueIdentifier)
                if let guardedWorkspace = workspace {

                    pushToWorkspace(workspace: guardedWorkspace)
                    return true
                }
                let notebook = try DataManager.shared().fetchNotebook(identifier: uniqueIdentifier)
                if let guardedNotebook = notebook {
                    
                    do {
                        let notebookWorkspace = try guardedNotebook.getWorkspace()
                        pushToNotebook(workspace: notebookWorkspace, notebook: guardedNotebook)
                        return true
                    }                  
                }
                let note = try DataManager.shared().fetchNote(identifier: uniqueIdentifier)
                if let guardedNote = note {
                    
                    do {
                        let noteNotebook = try guardedNote.getNotebook()
                        let noteWorkspace = try noteNotebook.getWorkspace()
                        pushToNote(workspace: noteWorkspace, notebook: noteNotebook, note: guardedNote)
                        return true
                    }
                }
            } catch {
                return false
                fatalError()
            }
            return true
        } else {
            return false
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
