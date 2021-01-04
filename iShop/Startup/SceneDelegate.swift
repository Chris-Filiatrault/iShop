//
//  SceneDelegate.swift
//  iShop
//
//  Created by Chris Filiatrault on 29/4/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   var globalVariables = GlobalVariableClass()
   
   var window: UIWindow?
   
   
   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
      // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
      // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
      
      
      
      // Get the managed object context from the shared persistent container.
      guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
         fatalError("Unable to read managed object context.")
      }
      
      
      
      // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
      // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
      let contentView = StartUp()
         .environment(\.managedObjectContext, context)
         .environmentObject(globalVariables)
         .environment(\.editMode, Binding.constant(EditMode.inactive))
      
      
      // Use a UIHostingController as window root view controller.
      // Modified window.rootViewController = UIHostingController(rootView: contentView)
      // to
      // window.rootViewController = HostingController(rootView: contentView)
      // (In order to change the status bar to light mode, using HostingController.swift)
      if let windowScene = scene as? UIWindowScene {
         let window = UIWindow(windowScene: windowScene)
         window.rootViewController = HostingController(rootView: contentView)
         self.window = window
         window.makeKeyAndVisible()
         
         
         // Change color scheme to light only (remove this if implementing dark mode)
         window.overrideUserInterfaceStyle = .light
         
      }
   }
   
   func sceneDidDisconnect(_ scene: UIScene) {
      // Called as the scene is being released by the system.
      // This occurs shortly after the scene enters the background, or when its session is discarded.
      // Release any resources associated with this scene that can be re-created the next time the scene connects.
      // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
   }
   
   func sceneDidBecomeActive(_ scene: UIScene) {
      // Called when the scene has moved from an inactive state to an active state.
      // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
      
      UIApplication.shared.isIdleTimerDisabled = UserDefaults.standard.bool(forKey: "syncKeepScreenOn")
      
      UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "syncNumTimesUsed") + 1, forKey: "syncNumTimesUsed")
      print("Num times used from Scene Delegate: \(UserDefaults.standard.integer(forKey: "syncNumTimesUsed"))")
   }
   
   func sceneWillResignActive(_ scene: UIScene) {
      // Called when the scene will move from an active state to an inactive state.
      // This may occur due to temporary interruptions (ex. an incoming phone call).
   }
   
   func sceneWillEnterForeground(_ scene: UIScene) {
      // Called as the scene transitions from the background to the foreground.
      // Use this method to undo the changes made on entering the background.
   }
   
   func sceneDidEnterBackground(_ scene: UIScene) {
      // Called as the scene transitions from the foreground to the background.
      // Use this method to save data, release shared resources, and store enough scene-specific state information
      // to restore the scene back to its current state.
      
      UIApplication.shared.isIdleTimerDisabled = false
      
      // Save changes in the application's managed object context when the application transitions to the background.
      (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
   }
   
}

