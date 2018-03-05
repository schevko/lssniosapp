//
//  WelcomeViewController.swift
//  LissenMe
//
//  Created by Şevket Erer on 6.03.2018.
//  Copyright © 2018 Şevket Erer. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "customer_name") as? String
        {
            performSegue(withIdentifier: "welcomeQrSegue", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "welcomeRegisterSegue", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
