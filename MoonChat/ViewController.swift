//
//  ViewController.swift
//  MoonChat
//
//  Created by Nagase Takuya on 2020/08/26.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UITableViewのデリゲートをViewControllerクラスで受け取る宣言
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTableView.rowHeight = 40
        
        // TableViewで利用するオリジナルのTableViewCellを利用するための設定
        let nib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        messageTableView.register(nib, forCellReuseIdentifier: "MessageTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // 表示するセルの個数
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 作成したオリジナルのTableViewCellを利用
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        //let cellnumber = String(indexPath.row+1)
        //cell.label.text = "cell" + cellnumber

        return cell
    }


}

