//
//  SceneDelegate.swift
//  TodoList
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TodoListAssembly.assembleTodoListModule()
        window?.makeKeyAndVisible()
    }
}

