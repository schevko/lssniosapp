//
//  QRViewController.swift
//  LissenMe
//
//  Created by Şevket Erer on 28.02.2018.
//  Copyright © 2018 Şevket Erer. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import Alamofire

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var ugBtn: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var qr_square: UILabel!
    
    var goUrl = String()

    @IBOutlet weak var lissen_logo: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"{
            let secondController = segue.destination as! ViewController
            secondController.myUrl = goUrl
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ugBtn.layer.cornerRadius = CGFloat(Float(5.0))
        self.ugBtn.layer.borderWidth = CGFloat(Float(1.0))
        self.ugBtn.layer.borderColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1).cgColor
        self.ugBtn.layer.backgroundColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1).cgColor
        
        self.qr_square.layer.borderWidth = CGFloat(Float(3.0))
        self.qr_square.layer.borderColor = UIColor.white.cgColor
        
        self.alertLabel.layer.opacity = 0.5
        self.qr_square.layer.opacity = 0.5
        
        
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
            //Session Olşturma
            let session = AVCaptureSession()
            //Kamerayı Tanıla
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            do
            {
                let input = try AVCaptureDeviceInput(device:captureDevice)
                session.addInput(input)
            }
            catch
            {
                print("ERROR")
            }
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode  ]
            self.video = AVCaptureVideoPreviewLayer(session: session)
            self.video.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.video)
            session.startRunning()
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    //Session Olşturma
                    let session = AVCaptureSession()
                    //Kamerayı Tanıla
                    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
                    do
                    {
                        let input = try AVCaptureDeviceInput(device:captureDevice)
                        session.addInput(input)
                    }
                    catch
                    {
                        print("ERROR")
                    }
                    let output = AVCaptureMetadataOutput()
                    session.addOutput(output)
                    output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    output.metadataObjectTypes = [AVMetadataObjectTypeQRCode  ]
                    self.video = AVCaptureVideoPreviewLayer(session: session)
                    self.video.frame = self.view.layer.bounds
                    self.view.layer.addSublayer(self.video)
                    session.startRunning()
                } else {
                    let alert = UIAlertController(title: "Dikkat", message: "Mekanın QR Kodunu okutabilmen için telefonunun kamerasını kullanmam gerekiyor.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ayarlar", style: .default, handler: { (_) in
                        DispatchQueue.main.async {
                            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
            })
        }
        
        
        
        
        
        self.view.bringSubview(toFront: ugBtn)
        self.view.bringSubview(toFront: lissen_logo)
        self.view.bringSubview(toFront: alertLabel)
        self.view.bringSubview(toFront: qr_square)
        
        
    
    }
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObjectTypeQRCode
                {
                    let alert = UIAlertController(title: "QR COde", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: {
                        (nil) in UIPasteboard.general.string = object.stringValue
                    }))

                    let customer_name: String = UserDefaults.standard.string(forKey: "customer_name")!
                    
                    var hasVenueUrl = "http://lissen.me/Main/hasVenue?venue_id="+object.stringValue
                    if let encodedhas = goUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                        let urlhas = URL(string: encodedhas)
                    {
                        hasVenueUrl = "\(urlhas)"
                    }
                    
                    Alamofire.request(hasVenueUrl).responseJSON { response in
                        print("Request: \(String(describing: response.request))")   // original url request
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            if utf8Text == "1"
                            {
                                self.goUrl = "http://lissen.me?venue_id="+object.stringValue+"&customer_name=\(customer_name)"
                                if let encoded = self.goUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                                    let url = URL(string: encoded)
                                {
                                    self.goUrl = "\(url)"
                                }
                                print(self.goUrl)
                                self.performSegue(withIdentifier: "segue", sender: self)
                            }else{
                                let alerthas = UIAlertController(title: "Dikkat", message: "Hatalı Barkod Okuttunuz!", preferredStyle: .alert)
                                alerthas.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                                self.present(alerthas, animated: true, completion: nil)
                            }
                        }
                    }
                
                }
            }//end if
        }
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
