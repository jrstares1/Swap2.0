//
//  ScanViewController.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 10/17/20.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController,  UIImagePickerControllerDelegate & UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to create videoCaptureDevice")
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        //checking to see if the device we are running can capture video
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed(message: "input")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed(message: "output")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed(message: String) {
        print("Error with the " + message)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    //If we found some data in the qr code
    func found (code: String) {
        
        let ac = UIAlertController(title: "Swap Successful!", message: nil, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Dismiss", style: .default) { [unowned ac] _ in
            _ = ac
            self.saveQRData(code: code)
            self.captureSession.startRunning()
        }
        
        ac.addAction(submitAction)
        self.present(ac, animated: true)
    }

    func saveQRData(code: String) {
        //Going to change this to whatever our landing page is; google is just a placeholder
        let userId = code.replacingOccurrences(of: "http://www.google.com/?uid=", with: "")
        let serialQueue = DispatchQueue(label: "tesingqueue")
        print("User ID is: " + userId)
        var userData = [String:String]()
        serialQueue.async {
            userData = swapWith(string: userId)
        }
        serialQueue.async {
            print("Received user data is: \(userData)")
        }
       
        
    }
    
    //folliwng function start or stop the capture session if the view
    //is about to appear or disappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
}
