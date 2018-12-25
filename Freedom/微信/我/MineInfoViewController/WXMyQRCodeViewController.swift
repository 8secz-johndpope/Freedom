//
//  WXMyQRCodeViewController.swift
//  Freedom

import Foundation
class WXMyQRCodeViewController: WXBaseViewController {
    var qrCodeVC = WXQRCodeViewController()
    var user: WXUser = WXUser() {
        didSet {
            qrCodeVC.avatarURL = user.avatarURL
            qrCodeVC.username = user.showName
            qrCodeVC.subTitle = user.detailInfo.location
            qrCodeVC.qrCode = user.userID
            qrCodeVC.introduction = "扫一扫上面的二维码图案，加我微信"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        navigationItem.title = "我的二维码"
        view.addSubview(qrCodeVC.view)
        addChild(qrCodeVC)
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_more"), style: .done, target: self, action: #selector(WXMyQRCodeViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.user = WXUserHelper.shared.user
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        var ac: UIAlertAction
        var vc: UIViewController?
        for viewController in navigationController?.viewControllers ?? []{
            if (NSStringFromClass(object_getClass(viewController) ?? NSObject.self) == "TLScanningViewController") {
                vc = viewController
            }
        }

        if vc != nil {
            ac = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        } else {
            ac = UIAlertAction(title: "扫描二维码", style: .default, handler: { action in
//                let scannerVC = WXScanningViewController()
//                scannerVC.disableFunctionBar = true
//                self.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(scannerVC, animated: true)
            })
        }
        showAlerWithtitle(nil, message: nil, style: UIAlertController.Style.actionSheet, ac1: {
            return UIAlertAction(title: "换个样式", style: .default, handler: { action in
            })
        }, ac2: {
            return UIAlertAction(title: "保存图片", style: .default, handler: { action in
                self.qrCodeVC.saveQRCodeToSystemAlbum()
            })
        }, ac3: {
            return ac
        }, completion: nil)
    }
}
