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
    private var message: String = ""
    private var messages: [String]  = []
    
    private let socketManager = SocketManager(socketURL: URL(string:"http://10.233.164.162:5000")!, config: [.log(true), .compress])
    private var socketIOClient : SocketIOClient!
    
    @IBAction func tapSendButton(_ sender: UIButton) {
        let m = textField.text ?? ""
        //message = "{ \"message\": " + m + "}"
        self.socketIOClient.emit("text", m)
        //messages.insert(textField.text ?? "", at: 0)
        textField.text = ""
        //messageTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UITableViewのデリゲートをViewControllerクラスで受け取る宣言
        messageTableView.delegate = self
        messageTableView.dataSource = self
        textField.delegate = self
        
        messageTableView.rowHeight = 40
        messageTableView.tableFooterView = UIView(frame: .zero) //不要なSeparatorが消える

        
        // TableViewで利用するオリジナルのTableViewCellを利用するための設定
        let nib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        messageTableView.register(nib, forCellReuseIdentifier: "MessageTableViewCell")

        setupSocketIO()
        }
        
    private func setupSocketIO() {
        //guard let friend = friend else { return }

        socketIOClient = socketManager.defaultSocket
        
        socketIOClient.on(clientEvent: .connect){ data, ack in
            print("socket connected!")
            self.socketIOClient.emit("joined", "")
            print("socket joined")
        }
        
        socketIOClient.on(clientEvent: .disconnect){data, ack in
            print("socket disconnected!")
        }
        
        socketIOClient.on("message") { (data, ack) in
            print("success")
            print(data)
            
//            if let paydata = data[0] as? NSMutableDictionary {
//                paydata.
//            }
            if let messageArr = data as? [[String:String]] {
                print("message: \(messageArr)")
                
                print(messageArr[0]["msg"]!)

                self.messages.insert(messageArr[0]["msg"]!, at: 0)
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
        print("Notificationを発行")
    }
    
    /// キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
        print("keyboardWillShowを実行")
    }
    
    /// キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
