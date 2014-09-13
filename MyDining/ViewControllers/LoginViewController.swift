//
//  LoginViewController.swift
//  MyDining
//
//  Created by Ian McDowell on 9/13/14.
//  Copyright (c) 2014 Ian McDowell. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginComplete();
    func loginCancelled();
}

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate!
    
    @IBOutlet var emailBox: UITextField!
    @IBOutlet var passwordBox: UITextField!

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
        if (emailBox.text == "" || passwordBox == "") {
            // invalid
            return;
        }
        // start network task to login
        
    }
    
    func login(username: String, password: String) {
        
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
