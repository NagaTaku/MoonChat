//
//  FriendListViewController.swift
//  MoonChat
//
//  Created by Fujimoto Akira on 2020/08/27.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var navifationItem: UINavigationItem!
    
    let friends = [Friend("aaa"), Friend("bbb"), Friend("ccc")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        
        navigationItem.title = "Friend List"
        
        // TableViewで利用するオリジナルのTableViewCellを利用するための設定
       let nib = UINib(nibName: "FriendListTableViewCell", bundle: nil)
       friendListTableView.register(nib, forCellReuseIdentifier: "FriendListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = friendListTableView.indexPathForSelectedRow {
            friendListTableView.deselectRow(at: indexPath, animated: true)
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
