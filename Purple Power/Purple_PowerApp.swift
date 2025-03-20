import SwiftUI
import FirebaseCore
import FirebaseMessaging
import FirebaseAnalytics

@main
struct Purple_PowerApp: App {
    
    @UIApplicationDelegateAdaptor(VPowerDelegateClass.self) var vPowerDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class VPowerDelegateClass: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let pushId = response.notification.request.content.userInfo["push_id"] as? String
        UserDefaults.standard.set(pushId, forKey: "push_id")
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            NotificationCenter.default.post(name: Notification.Name("firebase_token"), object: nil, userInfo: ["token": token])
        }
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: { _, _ in
                    
                }
            )
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        startAnalytics()
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let pushId = notification.request.content.userInfo["push_id"] as? String
        UserDefaults.standard.set(pushId, forKey: "push_id")
        completionHandler([.badge, .sound, .alert])
    }
    
    private func startAnalytics() {
        Analytics.setAnalyticsCollectionEnabled(true)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
}
