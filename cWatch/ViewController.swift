//  ViewController.swift
//  cWatch
//  Created by Ali on 2/22/20.
//  Copyright © 2020 Ali. All rights reserved.
//
import UIKit
import AVFoundation
import SqueezeButton
class ViewController: UIViewController {

    @IBOutlet var screenFrame: UIView!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var image: UIImage?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    private var flashMode: AVCaptureDevice.FlashMode = .on
    private func getSettings(camera: AVCaptureDevice, flashMode: AVCaptureDevice.FlashMode) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()

        if camera.hasFlash {
            settings.flashMode = flashMode
        }
        return settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait;
        let screenHeight = screenFrame.bounds.height
        let screenWidth = screenFrame.bounds.width
        let buttonXValue = screenWidth/2
        let buttonYValue = screenHeight-100;
        let button = SqueezeButton(frame: CGRect(x:buttonXValue-33, y: buttonYValue, width: 65, height: 65))
        button.layer.borderWidth = 3;
        //button.layer.borderColor = UIColor.green.cgColor;
        button.backgroundColor = .white
        button.layer.cornerRadius = button.frame.size.width/2
//        let c1 = UIColor(red: 155/255, green: 184/255, blue: 147/255, alpha: 1)
//        let c2 = UIColor(red: 168/255, green: 245/255, blue: 242/255, alpha: 1)
//        button.addGradient(startColor: c1, endColor: c2, angle: CGFloat.pi * 0.5)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        let switchDemo = UISwitch(frame:CGRect(x: 25, y:view.frame.height-75 , width: 0, height: 0))
               switchDemo.isOn = true
               switchDemo.setOn(true, animated: false)
               switchDemo.onTintColor = .yellow;
               switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
               self.view!.addSubview(switchDemo)

         setupCaptureSession()
         setupDevice()
         setupInputOutput()
         setupPreviewLayer()
         startRunningCaptureSession()
    }

    func setupCaptureSession(){
    captureSession.sessionPreset = AVCaptureSession.Preset.photo // this allows me to take the photo in full res
        
    }
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)// this specifies the camera type
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if (device.position == AVCaptureDevice.Position.back){// tells me if the camera is front or back facing
                backCamera = device
            }else if( device.position == AVCaptureDevice.Position.front ){
                frontCamera = device
            }
        }
        currentCamera = backCamera // use this to set the default to the back camera
    }
    
    func setupInputOutput(){// caputure the device inputs
        
        do{// error might be thrown so add this to handle an error
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }catch{
            print(error);
        }
    }

    func setupPreviewLayer(){
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame=self.view.frame;
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    var flashOn=false;
    @objc func switchValueDidChange(_ sender: UISwitch!) -> Bool{
             if (sender.isOn == true){
                flashOn = true;
             }else{
                flashOn = false;
             }
        return flashOn;
         }
    
    @objc func buttonAction(sender: UIButton!) {
        //sender.backgroundColor = .black
        if(flashOn==false){
            print("the flash was turned off ");
            let settings = AVCapturePhotoSettings();
            photoOutput?.capturePhoto(with: settings, delegate: self)
             // performSegue(withIdentifier: "showPhotoTaken", sender: nil)
        }
        else {
            print("the flash was turned on ");
                  let settings = getSettings(camera:backCamera!, flashMode: flashMode)
                  photoOutput?.capturePhoto(with: settings, delegate: self)
        }
          }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }

    override func prepare(for segue: UIStoryboardSegue,sender: Any?){
    if( segue.identifier == "showPhotoTaken"){
        
        let previewVC = segue.destination as! imageViewController
       previewVC.image = self.image;
    }
  }
}

extension ViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
            
            performSegue(withIdentifier: "showPhotoTaken", sender: nil)
        }
    }
}
