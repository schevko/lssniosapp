//
//  QRViewController.swift
//  LissenMe
//
//  Created by Şevket Erer on 28.02.2018.
//  Copyright © 2018 Şevket Erer. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var goUrl = String()

    @IBOutlet weak var lissen_logo: UIImageView!
    @IBOutlet weak var label1: UILabel!
    var video = AVCaptureVideoPreviewLayer()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondController = segue.destination as! ViewController
        secondController.myUrl = goUrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: label1)
        self.view.bringSubview(toFront: lissen_logo)
        
        session.startRunning()
    
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
                    
                    
                    goUrl = "http://lissen.me?venue_id="+object.stringValue+"&customer_name=\(customer_name)"
                    
                    if let encoded = goUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                        let url = URL(string: encoded)
                    {
                        goUrl = "\(url)"
                    }
                    
                    print(goUrl)
                    
                    //present(alert, animated: true, completion: nil)
                    performSegue(withIdentifier: "segue", sender: self)
                }
            }
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
