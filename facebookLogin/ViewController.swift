//
//  ViewController.swift
//  facebookLogin
//
//  Created by Anton Chugunov on 17/04/17.
//  Copyright © 2017 antonson10. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate {
    @IBOutlet weak var facebookUsername: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    var facebookAvatar: FBSDKProfilePictureView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        facebookLoginButton.readPermissions = ["public_profile"]
        facebookLoginButton.delegate = self
        drawShadow()
        if((FBSDKAccessToken.current()) == nil)
        {
            facebookUsername.text = "Not authorized!"
        }
        else
        {
            if(FBSDKAccessToken.current().permissions.contains("public_profile"))
            {
                fetchUserProfileData()
            }
        }
    }
    
    func drawShadow()
    {
        shadowView.layer.cornerRadius = shadowView.frame.size.height * 0.5
        shadowView.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.5
        shadowView.clipsToBounds = false
        
        facebookAvatar = FBSDKProfilePictureView.init(frame: shadowView.frame)
        facebookAvatar.layer.borderWidth = 2.0
        facebookAvatar.layer.borderColor = UIColor.blue.cgColor
        facebookAvatar.clipsToBounds = true
        shadowView.addSubview(facebookAvatar)
        facebookAvatar.frame.origin = CGPoint.init(x: 0, y: 0)
        facebookAvatar.layer.cornerRadius = facebookAvatar.frame.size.height * 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if(error == nil)
        {
            if(result.token != nil)
            {
                if(result.grantedPermissions.contains("public_profile"))
                {
                    fetchUserProfileData()
                }
            }
        }
    }
    
    func fetchUserProfileData()
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "id, name, picture"]).start(completionHandler: { (connection, result, error) in
            if (error == nil){
                print(result ?? "hmmmm")
                let data = result as! NSDictionary
                self.facebookUsername.text = data.object(forKey: "name") as? String
                self.facebookAvatar.profileID = data.object(forKey: "id") as? String
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        facebookUsername.text = "Not authorized!"
    }


}

