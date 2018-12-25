//
//  WXGroupViewController.swift
//  Freedom
import SnapKit
import Foundation
class WXGroupSearchViewController: WXTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var groupData: [WXGroup] = []
    private var data: [WXGroup] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WXGroupCell.self, forCellReuseIdentifier: "TLGroupCell")
        automaticallyAdjustsScrollViewInsets = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: TopHeight + 20, width: tableView.frame.size.width, height: APPH - tableView.frame.origin.y)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLGroupCell") as! WXGroupCell
        let group = data[indexPath.row]
        cell.group = group
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        data.removeAll()
        for group: WXGroup in groupData {
            if group.groupName.contains(searchText) || group.pinyin.contains(searchText) || group.pinyinInitial.contains(searchText){
                data.append(group)
            }
        }
        tableView.reloadData()
    }
}

class WXGroupCell: WXTableViewCell {
    var group: WXGroup = WXGroup() {
        didSet {
            let path = FileManager.pathUserAvatar(group.groupAvatarPath)
            let image = UIImage(named: path) ?? UIImage(named: PuserLogo)
            avatarImageView.image = image
            usernameLabel.text = group.groupName
        }
    }
    private var avatarImageView = UIImageView()
    private var usernameLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftSeparatorSpace = 10
        usernameLabel.font = UIFont.systemFont(ofSize: 17.0)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(9.5)
            make.bottom.equalTo(-9)
            make.width.equalTo(self.avatarImageView.snp.height)
        }
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.centerY.equalTo(self.avatarImageView)
            make.right.lessThanOrEqualTo(self.contentView).offset(-20)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WXGroupViewController: WXTableViewController ,UISearchBarDelegate {
    private lazy var searchController: WXSearchController =  {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        return searchController
    }()
    var searchVC = WXGroupSearchViewController()
    var data: [WXGroup] = WXFriendHelper.shared.groupsData
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "群聊"
        view.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(WXGroupCell.self, forCellReuseIdentifier: "TLGroupCell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group: WXGroup = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLGroupCell") as! WXGroupCell
        cell.group = group
        cell.bottomLineStyle = (indexPath.row == data.count - 1 ? .fill : TLCellLineStyle.default)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = data[indexPath.row]
        let chatVC = WXChatViewController.shared
        chatVC.partner = group
        let vc: UIViewController = WXTabBarController.shared.children[0]
        WXTabBarController.shared.selectedIndex = 0
        vc.hidesBottomBarWhenPushed = true
        vc.navigationController?.pushViewController(chatVC, animated: true)
        self.navigationController?.popViewController(animated: false)
        vc.hidesBottomBarWhenPushed = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.groupData = data
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}
