import UIKit
import RxSwift
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        
        UINavigationBar.appearance().tintColor = .appSubColor
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appSubColor]

        if !AppUserDefaults.getAuthToken().isEmpty {
            let vc = MainTabController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            return true
        }
        
        let vc = TopViewController()
        var routing: TopRouting = TopRoutingImpl()
        routing.viewController = vc
        var ui: TopUI = TopUIImpl()
        ui.viewController = vc
        vc.inject(ui: ui, routing: routing, disposeBag: DisposeBag())
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
