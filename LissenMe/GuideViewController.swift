//
//  guideViewController.swift
//  LissenMe
//
//  Created by Şevket Erer on 5.03.2018.
//  Copyright © 2018 Şevket Erer. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var tbBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tbBtn.layer.backgroundColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1).cgColor
        self.tbBtn.layer.cornerRadius = CGFloat(Float(5.0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
