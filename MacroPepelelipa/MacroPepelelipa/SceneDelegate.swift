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
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if self.window?.traitCollection.userInterfaceStyle == .dark {
                self.changeIcon(to: "DarkModeIcon")
            } else {
                self.changeIcon(to: nil)
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    /**
    In this method, the icon of the application is changed. This happens by setting the alterate icon to a different icon in the application.
     - Parameter iconName: The String containing the name of the icon being changed to.
     */
    private func changeIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }
            
        UIApplication.shared.setAlternateIconName(iconName, completionHandler: { (error) in
                if let error = error {
                    print("App icon failed to change due to \(error.localizedDescription)")
            }
        })
    }
}
