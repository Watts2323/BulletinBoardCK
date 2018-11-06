//
//  AppDelegate.swift
//  BulletinBoardCloudKit
//
//  Created by Xavier on 11/5/18.
//  Copyright © 2018 Xavier ios dev. All rights reserved.
//

// DO NOT ACTUALLY REQUEST NOTIFICATIONS OUT OF THE APPS DELEGATE, YOU WOULD DO IT IN CLOUDKit Manager

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Declarring the notification Name
    static let remoteNotificationReceived = Notification.Name(rawValue: "remoteNotificationReceived")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //If they did authorize for notifications then...
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (didAuth, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription) ")
                return
            }
            if didAuth == true {
                //We can register for remote notification
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                //Do something else
            }
        }

        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let querySubscription = CKQuerySubscription(recordType: Message.messageTypeKey, predicate: NSPredicate(value: true), subscriptionID: UUID().uuidString, options: .firesOnRecordCreation)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = " New Message"
        notificationInfo.alertBody = "There was a new Message added to the Board 😉"
        
        querySubscription.notificationInfo = notificationInfo
        
        MessageController.shared.publicDatabase.save(querySubscription) { (_, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription) ")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Radio tower sending an Internal Notification
        NotificationCenter.default.post(name: AppDelegate.remoteNotificationReceived, object: nil)
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: AppDelegate.remoteNotificationReceived, object: nil)
    }


}

