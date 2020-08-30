//
//  FriendListViewController.swift
//  MoonChat
//
//  Created by Fujimoto Akira on 2020/08/27.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import UIKit
import LineSDK

class FriendListViewController: UIViewController {

    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var navifationItem: UINavigationItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var friends = [Friend("aaa"), Friend("bbb"), Friend("ccc")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        
        navigationItem.title = "Friend List"
        
        // TableViewで利用するオリジナルのTableViewCellを利用するための設定
       let nib = UINib(nibName: "FriendListTableViewCell", bundle: nil)
       friendListTableView.register(nib, forCellReuseIdentifier: "FriendListTableViewCell")
        
        if let token = AccessTokenStore.shared.current {
            print("Token expires at:\(token.expiresAt)") // アクセストークンの有効期限
            print("Token value:\(token.value)") // 現在のアクセストークン
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = friendListTableView.indexPathForSelectedRow {
            friendListTableView.deselectRow(at: indexPath, animated: true)
        }
        
        API.Auth.verifyAccessToken { result in
            switch result {
            case .success(let value):
                print("Token expires in: \(value.expiresIn)")
                if let userID = UserDefaults.standard.string(forKey: "user_id") {
                    print(userID)
                    self.loginButtonSet(isLogin: true)
                }else {
                    self.loginButtonSet(isLogin: false)
                }
            case .failure(let error):
                print(error)
                self.loginButtonSet(isLogin: false)
            }
        }
    }
    
    // ログイン、ログアウトボタンのセット
    func loginButtonSet(isLogin: Bool) -> Void {
        self.loginButton.isEnabled = !isLogin
        self.logoutButton.isEnabled = isLogin
    }
    
    // "+"ボタンがタップされたら友達追加画面に遷移
    @IBAction func tapedAddButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "FriendAddViewController", bundle: nil)
        let friendAddVC = storyboard.instantiateInitialViewController()! as FriendAddViewController
        friendAddVC.parentVC = self
        self.navigationController?.pushViewController(friendAddVC, animated: true)
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "LoginViewController", bundle: nil)
        let loginAddVC = storyboard.instantiateInitialViewController()! as LoginViewController
        self.navigationController?.pushViewController(loginAddVC, animated: true)
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        LoginManager.shared.logout { result in
            switch result {
            case .success:
                print("Logout Succeeded")
                self.logoutButton.isEnabled = false
                self.loginButton.isEnabled = true
                UserDefaults.standard.removeObject(forKey: "user_id")
                UserDefaults.standard.removeObject(forKey: "user_name")
                UserDefaults.standard.removeObject(forKey: "pic_url")
            case .failure(let error): print("Logout Failed: \(error)")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FriendListViewController: UITableViewDelegate {
    
}

extension FriendListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListTableViewCell", for: indexPath) as! FriendListTableViewCell
        cell.nameLabel.text = friends[indexPath.row].name
        cell.iconImageView.image = friends[indexPath.row].icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ChatViewController", bundle: nil)
        let chatVC = storyboard.instantiateInitialViewController()! as ChatViewController
        chatVC.friend = friends[indexPath.row]
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}
