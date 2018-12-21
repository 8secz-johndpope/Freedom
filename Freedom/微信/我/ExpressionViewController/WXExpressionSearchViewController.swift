//
//  WXExpressionSearchViewController.swift
//  Freedom

import Foundation
class WXExpressionSearchViewController: WXTableViewController, UISearchResultsUpdating, UISearchBarDelegate, WXExpressionCellDelegate {
    var proxy = WXExpressionHelper.shared
    var data: [Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tableView.register(WXExpressionCell.self, forCellReuseIdentifier: "TLExpressionCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = CGRect(x: 0, y: Int(TopHeight) + 20, width: APPW, height: APPH - 20 - Int(TopHeight))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLExpressionCell") as WXExpressionCell
        let group: TLEmojiGroup = data[indexPath.row]
        cell.group = group
        cell.delegate = self
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = data[indexPath.row] as TLEmojiGroup
        let detailVC = WXExpressionDetailViewController()
        detailVC.group = group
        let navC = WXNavigationController(rootViewController: detailVC)
        let closeButton = UIBarButtonItem(title: "关闭", style: UIBarButtonItem.Style.plain, actionBlick: {
            navC.dismiss(animated: true) {
            }
        })
        detailVC.navigationItem.leftBarButtonItem = closeButton
        present(navC, animated: true) {
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func expressionCellDownloadButtonDown(_ group: TLEmojiGroup) {
        group.status = .downloading
        proxy.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: 1, success: { data in
            group.data = data
            WXExpressionHelper.shared().downloadExpressions(withGroupInfo: group, progress: { progress in

            }, success: { group in
                group.status = TLEmojiGroupStatusDownloaded
                var index: Int = nil
                if let aGroup = group {
                    index = self.data.index(of: aGroup)
                }
                if (index) < self.data.count {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
                let ok = WXExpressionHelper.shared().addExpressionGroup(group)
                if !ok {
                    if let aName = group.groupName {
                        SVProgressHUD.showError(withStatus: "表情 \(aName) 存储失败！")
                    }
                }
            }, failure: { group, error in

            })
        }, failure: { error in
            if let aName = group.groupName {
                SVProgressHUD.showError(withStatus: "\"\(aName)\" 下载失败: \(error)")
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        if (keyword.count) > 0 {
            SVProgressHUD.show()
            proxy().requestExpressionSearch(byKeyword: keyword, success: { data in
                self.data = data
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }, failure: { error in
                self.data = nil
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: error)
            })
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
    }

}
