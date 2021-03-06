//
//  ViewController.swift
//  MoonChat
//
//  Created by Nagase Takuya on 2020/08/26.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    private var messages: [Message]  = []
    
    
    private let socketManager = SocketManager(socketURL: URL(string:"http://10.233.164.162:5000")!, config: [.log(true), .compress])
    private var socketIOClient : SocketIOClient!
    
    @IBAction func tapSendButton(_ sender: UIButton) {
        let message = textField.text ?? ""
        let messageDic = ["msg":message]
        self.socketIOClient.emit("text", messageDic)
        textField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UITableViewのデリゲートをViewControllerクラスで受け取る宣言
        messageTableView.delegate = self
        messageTableView.dataSource = self
        textField.delegate = self
        
        messageTableView.rowHeight = 50
        messageTableView.separatorStyle = .none //不要なSeparatorが消える
        
        // TableViewで利用するオリジナルのTableViewCellを利用するための設定
        let nib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        messageTableView.register(nib, forCellReuseIdentifier: "MessageTableViewCell")

        setupSocketIO()
    }
        
    // socketIOの設定
    private func setupSocketIO() {
        socketIOClient = socketManager.defaultSocket
        
        socketIOClient.on(clientEvent: .connect){ data, ack in
            print("socket connected!")
            self.socketIOClient.emit("joined", "")
        }
        
        socketIOClient.on(clientEvent: .disconnect){data, ack in
            print("socket disconnected!")
        }
        
        socketIOClient.on("message") { (data, ack) in
            if let messageArr = data as? [[String:Any]] {
                let dateUnix: TimeInterval = messageArr[0]["time"] as! Double
                self.messages.append(Message(messageArr[0]["msg"] as! String, dateUnix: dateUnix))
                self.messageTableView.reloadData()
            }
        }
        
        socketIOClient.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()  //Notification発行
    }


    // MARK: - Notification

    /// Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height - (rect.size.height))
        }
    }
    
    /// キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: UIScreen.main.bounds.size.height)
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.messageLabel.text = messages[indexPath.row].message
        cell.dateLabel.text = messages[indexPath.row].getDateString()
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
