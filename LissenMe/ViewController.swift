//
//  ViewController.swift
//  LissenMe
//
//  Created by Şevket Erer on 28.02.2018.
//  Copyright © 2018 Şevket Erer. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController { 
    
    var myUrl = String()
    
    @IBOutlet weak var webGoruntuleme: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let adres = URL(string: myUrl)
        let baglantiTalebi = URLRequest(url: adres!)
        
        webGoruntuleme.load(baglantiTalebi)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

