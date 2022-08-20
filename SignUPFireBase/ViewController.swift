//
//  ViewController.swift
//  SignUPFireBase
//
//  Created by Amit Kumar Singh on 17/08/22.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Accounts
var arr = [0,1,2]

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func googleButton(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "922354945451-hbhf6grmjnf2f10658icr6i867lj71u0.apps.googleusercontent.com")
        //        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let emailAddress = user?.profile?.email
            let fullName = user?.profile?.name
            let givenName = user?.profile?.givenName
            let familyName = user?.profile?.familyName
            print("Full Name :\(String(describing: fullName)) \n Given Name: \(String(describing: givenName)) \n Email Address : \(String(describing: emailAddress)) \n Family Name: \(String(describing: familyName))")
        }
    }
    
    @IBAction func faceBookButton(_ sender: UIButton) {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile , .email, .userGender, .userBirthday], viewController: self, completion: {( result) in
            switch result {
            case .cancelled : print("User Cancled")
            case .failed(let error) : print("error \(error)")
            case .success: if let token = AccessToken.current,
                              !token.isExpired {
                let token = token.tokenString
                let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":  "email, first_name, last_name, picture, name, birthday, gender"], tokenString: token, version: nil, httpMethod: .get)
                request.start { (_ , result, _) in
                    print("\(result ?? "")")
                }
            }
            }
        })
    }
    
    @IBAction func appleSignIn(_ sender: UIButton) {
        //        appleLogin()
        // print(arr[3])
    }
}
