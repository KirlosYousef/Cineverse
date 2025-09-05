//
//  AppDelegate.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import UIKit
import SDWebImage
import TelemetryDeck

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Configure SDWebImage for better memory management
        loadRocketSimConnect()
        configureSDWebImage()
        configureTelemetryDeck()
        return true
    }
    
    private func loadRocketSimConnect() {
        #if DEBUG
        guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
            print("Failed to load linker framework")
            return
        }
        print("RocketSim Connect successfully linked")
        #endif
    }
    
    private func configureTelemetryDeck() {
        let config = TelemetryDeck.Config(appID: "004CB05B-ACDF-42C7-9EDC-D10E2322ECB2")
        TelemetryDeck.initialize(config: config)
        TelemetryService.shared.send(TelemetryService.Signal.appStarted)
    }
    
    private func configureSDWebImage() {
        // Set memory cache size limit (50MB)
        SDImageCache.shared.config.maxMemoryCost = 50 * 1024 * 1024
        // Set disk cache size limit (100MB)
        SDImageCache.shared.config.maxDiskSize = 100 * 1024 * 1024
        // Enable memory cache cleanup on memory warning
        SDImageCache.shared.config.shouldUseWeakMemoryCache = true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

