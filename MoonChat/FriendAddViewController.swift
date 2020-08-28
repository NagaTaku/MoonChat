//
//  FriendAddViewController.swift
//  MoonChat
//
//  Created by Fujimoto Akira on 2020/08/28.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import UIKit

class FriendAddViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var parentVC: FriendListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.delegate = self
        
        navigationItem.title = "友達追加"
        searchTextField.placeholder = "IDを入力"
        
        // 検索ボタンの設定
        searchButton.setTitle("検索", for: .normal)
//        searchButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
//        searchButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = .green
    }
    
    @IBAction func tapSearchButton(_ sender: Any) {
        let newFriend = Friend("Hoge")
        let alertController = UIAlertController(title: newFriend.name, message: "友達を追加しますか", preferredStyle: .alert)
        
        // アラートダイアログに追加するOKボタン
        let oKAlertAction = UIAlertAction(title: "OK", style: .default) {[weak self] (action) in
            // OKボタンをタップした時の処理
            // TODO 友達を追加する処理
            self?.parentVC.friends.append(newFriend)
            // 友達リストに戻る
            self?.navigationController?.popViewController(animated: true)
        }
        // アラートダイアログに追加するキャンセルボタン
        let cancelAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        // 各パーツをUIAlertControllerに追加
        alertController.addAction(oKAlertAction)
        alertController.addAction(cancelAlertAction)
        
        // アラートダイアログを表示する
        present(alertController, animated: true, completion: nil)
    }
    
    // NavigationCotrollerで戻る処理 friendListを更新
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let parentVC = viewController as? FriendListViewController {
            parentVC.friendListTableView.reloadData()
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
