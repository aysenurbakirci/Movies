//
//  SceneDelegate.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: MainPageBuilder.build())
        self.window = window
        window.makeKeyAndVisible()
    }
}
