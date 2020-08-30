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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在所持しているアクセストークン
        if let token = AccessTokenStore.shared.current {
            print("Token expires at:\(token.expiresAt)") // アクセストークンの有効期限
            print("Token value:\(token.value)") // 現在のアクセストークン
            self.navigationController?.popViewController(animated: true)
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
        
        // LINEのプロフィール情報をUserDefaultsに保存
        if let profile = loginResult.userProfile {
            UserDefaults.standard.set(profile.userID, forKey: "user_id")
            UserDefaults.standard.set(profile.displayName, forKey: "user_name")
            print(profile.userID)
            print(profile.displayName)
            if let picURL = profile.pictureURL {
                UserDefaults.standard.set(picURL, forKey: "pic_url")
                print(picURL)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        print("Error: \(error)")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
        print("Login Started.")
    }
    
}
