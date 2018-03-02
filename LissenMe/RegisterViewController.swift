//
//  RegisterViewController.swift
//  LissenMe
//
//  Created by Şevket Erer on 1.03.2018.
//  Copyright © 2018 Şevket Erer. All rights reserved.
//

import UIKit
import Alamofire
import InputMask

class RegisterViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    var maskedDelegate: MaskedTextFieldDelegate!
    
    var goUrl = String()
    

    @IBOutlet weak var customer_name: UITextField!
    @IBOutlet weak var customer_phone: UITextField!
    @IBOutlet weak var customer_pass: UITextField!
    @IBOutlet weak var register_button: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //...
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maskedDelegate = MaskedTextFieldDelegate(format: "{0} ([000]) [000] [00] [00]")
        maskedDelegate.listener = self
        
        customer_phone.delegate = maskedDelegate
        
        //maskedDelegate.put(text: "0", into: customer_phone)
        
        //UserDefaults.standard.set("Test Datası", forKey: "Test")
        
        //Oluşturulmuş Datayı Sil
        //UserDefaults.standard.removeObject(forKey: "customer_name")

        self.customer_name.layer.cornerRadius = CGFloat(Float(5.0))
        self.customer_name.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.customer_name.layer.borderWidth = CGFloat(Float(1.0))
        
        self.customer_phone.layer.cornerRadius = CGFloat(Float(5.0))
        self.customer_phone.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.customer_phone.layer.borderWidth = CGFloat(Float(1.0))
        
        self.customer_pass.layer.cornerRadius = CGFloat(Float(5.0))
        self.customer_pass.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.customer_pass.layer.borderWidth = CGFloat(Float(1.0))
        
        self.register_button.layer.cornerRadius = CGFloat(Float(5.0))
        
        //UserDefaults.standard.set("Test", forKey: "test")
        
        
        
    }
    
    func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
        ) {
        print(value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "customer_name") as? String
        {
            performSegue(withIdentifier: "goToQrSegue", sender: self)
        }
        else
        {
            /*let alert = UIAlertController(title: "Dikkat", message: "Üye girişi yapılmadı", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)*/
            
        }
    }
    
    @IBAction func register_action(_ sender: Any) {
        
        //self.customer_name.text = "Tıklandı!"
        
        if self.customer_phone.text! == ""  || self.customer_pass.text! == "" || self.customer_name.text! == ""
        {
            let alert = UIAlertController(title: "Dikkat", message: "Lütfen boş alan bırakmayın!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        else
        {
            goUrl = "http://lissen.me/Main/registerUser?phone="+self.customer_phone.text!+"&pass="+self.customer_pass.text!+"&name="+self.customer_name.text!+""
            
            if let encoded = goUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded)
            {
                goUrl = "\(url)"
            }
            
            
            Alamofire.request(goUrl).responseJSON { response in
                
                print("Request: \(String(describing: response.request))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    if utf8Text == "1"
                    {
                        UserDefaults.standard.set(self.customer_name.text, forKey: "customer_name")
                        UserDefaults.standard.set(self.customer_phone.text, forKey: "customer_phone")
                        
                        self.performSegue(withIdentifier: "goToQrSegue", sender: self)
                    }
                    else
                    {
                        let alert2 = UIAlertController(title: "Dikkat", message: "Bu cep telefonu ile daha önceden kayıt olunmuş!", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                        
                        self.present(alert2, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    @IBAction func registerToLogin(_ sender: Any) {
        performSegue(withIdentifier: "registerToLogin", sender: self)
    }
    
    @IBAction func customer_nameExit(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func customer_phoneExit(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func customer_passExit(_ sender: Any) {
        self.resignFirstResponder()
    }
}
