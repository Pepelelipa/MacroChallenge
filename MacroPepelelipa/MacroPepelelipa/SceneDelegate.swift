//
//  SceneDelegate.swift
//  MacroPepelelipa
//
//  Created by Pedro Giuliano Farina on 15/09/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit

@available(iOS 14, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    weak static var sensitiveContent: SensitiveContentController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }
        let navController = UINavigationController()
        navController.navigationBar.tintColor = .actionColor
        navController.navigationBar.prefersLargeTitles = true
        
        navController.viewControllers = [WorkspaceSelectionViewController()]
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        if UIDevice.current.userInterfaceIdiom == .mac {
            scene.sizeRestrictions?.minimumSize = CGSize(width: UIScreen.main.bounds.width/3,
                                                         height: UIScreen.main.bounds.height/1.5)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        SceneDelegate.sensitiveContent?.saveSensitiveContent()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        let interfaceStyle = self.window?.traitCollection.userInterfaceStyle
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if interfaceStyle == .dark && !isDarkMode {
                self.changeIcon(to: "DarkModeIcon")
                UserDefaults.standard.setValue(true, forKey: "isDarkMode")
            } else if interfaceStyle == .light && isDarkMode {
                self.changeIcon(to: nil)
                UserDefaults.standard.setValue(false, forKey: "isDarkMode")
            }
        }
        SceneDelegate.sensitiveContent?.saveSensitiveContent()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        SceneDelegate.sensitiveContent?.saveSensitiveContent()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        SceneDelegate.sensitiveContent?.saveSensitiveContent()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        SceneDelegate.sensitiveContent?.saveSensitiveContent()
    }
    
    /**
    In this method, the icon of the application is changed. This happens by setting the alterate icon to a different icon in the application.
     - Parameter iconName: The String containing the name of the icon being changed to.
     */
    private func changeIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }
            
        UIApplication.shared.setAlternateIconName(iconName)
    }
}
