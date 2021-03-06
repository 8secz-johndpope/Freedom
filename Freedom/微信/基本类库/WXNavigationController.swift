//
//  WXNavigationController.swift
//  Freedom
import UIKit
final class WXNavigationController: BaseNavigationViewController {
    override public var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    var isFullScreenPopGesture: Bool {
        get {
            return type(of: interactivePopGestureRecognizer) == UIPanGestureRecognizer.self
        }
        set {
            if isFullScreenPopGesture {
                if type(of: interactivePopGestureRecognizer) == UIPanGestureRecognizer.self {
                    return
                }
                object_setClass(interactivePopGestureRecognizer, UIPanGestureRecognizer.self)
            } else {
                if type(of: interactivePopGestureRecognizer) == UIScreenEdgePanGestureRecognizer.self {
                    return
                }
                object_setClass(interactivePopGestureRecognizer, UIScreenEdgePanGestureRecognizer.self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
        appearance.backIndicatorImage = Image.left.image.withRenderingMode(.alwaysTemplate)
        appearance.setBackgroundImage(UIImage.imageWithColor(UIColor.back, size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.blackx,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)], for: UIControl.State())
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.dark ,NSAttributedString.Key.font : UIFont.big]
        navigationBar.barTintColor = UIColor.blackx
        navigationBar.tintColor = UIColor.dark
        view.backgroundColor = UIColor.whitex
    }
}
