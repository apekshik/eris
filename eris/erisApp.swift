//
//  erisApp.swift
//  eris
//
//  Created by Apekshik Panigrahi on 12/7/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
struct erisApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
      HomeView(fcmTokenData: delegate.tokenData)
    }
  }
}

// Configuring Firebase and Cloud Messaging for push notifications

class AppDelegate: NSObject, UIApplicationDelegate {
  let gcmMessageIDKey = "gcm.message_id"
  var tokenData: [String : Any] = [:]
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    FirebaseApp.configure()
    
    // Setting up Cloud Messaging
    Messaging.messaging().delegate = self
    
    // Setting up notifications...
    UNUserNotificationCenter.current().delegate = self

    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )

    
    application.registerForRemoteNotifications()
    return true
  }
  
  // [START receive_message]
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    // MARK: Do something with the message data here.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    return UIBackgroundFetchResult.newData
  }
  // [END receive_message]
  
  
  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }

  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
  // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
  // the FCM registration token.
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")

    // With swizzling disabled you must set the APNs token here.
    // Messaging.messaging().apnsToken = deviceToken
  }
}


// Cloud Messaging
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//    print("Firebase registration token: \(String(describing: fcmToken))")

//    let dataDict: [String: String] = ["token": fcmToken ?? ""]
//    NotificationCenter.default.post(
//      name: Notification.Name("FCMToken"),
//      object: nil,
//      userInfo: dataDict
//    )
//    // TODO: If necessary send token to application server.
//    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    tokenData = [
      "token": fcmToken ?? "",
      "createdAt": Date()
    ]
    
    // Store token in firestore for sending notifications from server in future...
    
    print("dataDict: \(tokenData)")
  }
}

// User Notifications, AKA in-app notifications.
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // ...

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
      return [[.banner, .badge, .sound]]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print("userInfo: \(userInfo)")
  }
}
