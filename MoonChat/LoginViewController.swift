//
//  LoginViewController.swift
//  MoonChat
//
//  Created by Nagase Takuya on 2020/08/28.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import UIKit
import LineSDK

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    var parentVC: FriendListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在所持しているアクセストークン
        if let token = AccessTokenStore.shared.current {
            print("Token expires at:\(token.expiresAt)") // アクセストークンの有効期限
            print("Token value:\(token.value)") // 現在のアクセストークン
            parentVC.navigationController?.popViewController(animated: true)
        }
        
        // Create Login Button.
        let loginButton = LoginButton()
        loginButton.delegate = self
        
        // Configuration for permissions and presenting.
        loginButton.permissions = [.profile]
        loginButton.presentingViewController = self
        
        // Add button to view and layout it.
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -80.0).isActive = true
    }
    
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        print("Login Succeeded.")
    
        LoginManager.shared.login(permissions: [.profile], in: self) {
            result in
                switch result {
                case .success(let loginResult):
                    let token = loginResult.accessToken.value
                    print("Getting token value:"+token)
                    // Send `token` to your server.
                case .failure(let error):
                    print(error)
                }
        }
        parentVC.navigationController?.popViewController(animated: true)
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        print("Error: \(error)")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
        print("Login Started.")
    }
    
}
