//
//  LoginViewController.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit
import Alamofire

protocol LoginViewControllerDelegate {
    func loginComplete();
    func loginCancelled();
}

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate!
    
    @IBOutlet var emailBox: UITextField!
    @IBOutlet var passwordBox: UITextField!
    
    var loggingIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailBox.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        // hide the keyboard
        emailBox.resignFirstResponder()
        passwordBox.resignFirstResponder()
        
        // dismiss the page and call the loginCancelled method of the delegate
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.delegate.loginCancelled()
        })
    }
    
    @IBAction func login(sender: AnyObject) {
        if (emailBox.text.isEmpty || passwordBox.text.isEmpty) {
            // invalid
            NSLog("Invalid input")
            return;
        }
        // start network task to login
        self.login(emailBox.text, password: passwordBox.text)
    }
    
    func login(username: String, password: String) {
        if (self.loggingIn == true) {
            return;
        }
        self.loggingIn = true;
        var url = "\(Utils.getBaseURL())/qp.dca?nmout=1&dx=02476843"
        NSLog(url)

        Networking.post(url, data: "uBasicUserLogin~\(username)~\(password)") { (data: String?, error: NSError?) -> Void in
            NSLog("Login done: \(data)")
            if (data!.rangeOfString("190|OK|") == nil) {
                var alert = UIAlertView(title: "Error", message: "Your login failed! :(", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                self.passwordBox.text = "";
                self.loggingIn = false
                return;
            }
            var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var account = Account();
            account.email = username;
            account.authID = (data! as NSString).stringByReplacingOccurrencesOfString("190|OK|", withString: "");
            
            // hide the keyboard
            self.emailBox.resignFirstResponder()
            self.passwordBox.resignFirstResponder()
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.delegate.loginComplete()
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
