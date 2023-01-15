//
//  SceneDelegate.swift
//  Custom_UIViewController_Transition
//
//  Created by Hyunwoo Jang on 2023/01/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let _ = (scene as? UIWindowScene) else { return }
  }
}

