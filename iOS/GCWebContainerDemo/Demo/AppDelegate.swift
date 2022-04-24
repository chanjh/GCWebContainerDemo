//
//  AppDelegate.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/17.
//

import Foundation
import UIKit
@_exported import GCWebContainer
@_exported import Pandora
@_exported import BrowserKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        PDManager.shared.tryToSetupAll()
        PDManager.shared.loadAll()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Config", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
