//
//  imageViewController.swift
//  cWatch
//
//  Created by Ali on 2/22/20.
//  Copyright © 2020 Ali. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI
import Firebase
import UserNotifications
import AVFoundation
import SwiftyJSON
import FirebaseStorage
import Photos
import SCLAlertView
import SqueezeButton


struct foodData{
       var foodDishes: [String]
       var foodDishesAccuracy: [Any]
   }
class imageViewController: UIViewController {
    var foodDishes = [String]()
//    struct foodData{
//        var foodDishes: [String]
//        var foodDishesAccuracy: [Any]
//    }
    var foodResult=foodData(foodDishes:["blank"], foodDishesAccuracy: [0])
    var image: UIImage!
    var activityView: UIActivityIndicatorView?
    var pass = false;
    let dispatchGroup = DispatchGroup()//You attach multiple work items to a group and schedule them for asynchronous execution

      let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    func displayMyAlertMessage(userMessage:String)// this function allows we to send a alert to the users screen when they do something with the delete button or possibly somehthing invalid
      {
          DispatchQueue.main.async {
          let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertController.Style.alert);
            
          let noAction = UIAlertAction(title:"No", style:UIAlertAction.Style.default, handler:{ (action) -> Void in
                        print("Okay  I will do nothing then ")
                   })
        
          let yesAction = UIAlertAction(title:"Yes", style:UIAlertAction.Style.default, handler:
            { (action) -> Void in
            self.dismiss(animated: false, completion: nil)
            
            })
              myAlert.addAction(noAction);
              myAlert.addAction(yesAction);
          self.present(myAlert, animated:true, completion:nil);
          }
      }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView?.color = .blue
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()  
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    @objc func deleteAction(sender: UIButton!) {
         showActivityIndicator();
        print("delete button was tapped");
        displayMyAlertMessage(userMessage:"Are you sure you want to delete the photo");
        hideActivityIndicator();
           }
    func writeToPhotoAlbum(image: UIImage) {
             UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
         }

         @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
             print("Save finished!")
         }
    
     var foodValues = [String]()
    func makePOSTRequest(personDictionary: Dictionary<String,String>) {
        print("first enter within post")
        dispatchGroup.enter()
            print(JSONSerialization.isValidJSONObject(personDictionary))
            guard let uploadData = try? JSONEncoder().encode(personDictionary) else{
                return
            }
                print(uploadData)
                let url = URL(string: "https://still-ocean-94761.herokuapp.com/product")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
                if let error = error{
                    print("error: \(error)")
                    return
                }
                let response = response as? HTTPURLResponse
                if let mimeType = response!.mimeType,
                mimeType == "application/json",
                let data = data,
                    var dataString = String(data:data, encoding: .utf8){
                    print("got data: \(dataString)")
                    dataString = dataString.replacingOccurrences(of: "\"" , with: "")
                    dataString = dataString.replacingOccurrences(of: "[" , with: "")
                    dataString = dataString.replacingOccurrences(of: "]" , with: "")
                    self.foodValues = dataString.components(separatedBy:",")
                  //  foodData.foodDishes = [dataString]//(foodDishes: [dataString], foodDishesAccuracy: [0])
                    //self.foodResult=foodData(foodDishes: [dataString], foodDishesAccuracy: [0])
                    print("first leave within post")
                    self.dispatchGroup.leave()
                }
            }
            task.resume()
        dispatchGroup.wait()
    }

     var correctFoods = [String]()

    @objc func submitAction(sender: UIButton!) {// this is where the logic goes for what happens when the user wants to send the data.
          showActivityIndicator();  // loading spinner indicator
          // writeToPhotoAlbum(image:image);  // saves the photo to the users library
        // prepare the data to be sent to the fireBase storage
        
        print("i got to the area to send the image")
        guard let imageData = image!.jpegData(compressionQuality: 0.8) else {
             print("Error in preparing the image to send to fireBase")
            return ;
        }
        let reference = Storage.storage().reference().child("test");
        let metadata = StorageMetadata()
         print("i got to the area to send the image now i am connecting to the network")
        metadata.contentType = "image/jpeg"
        reference.putData(imageData, metadata:metadata, completion: { (metadata, error) in
             // 3
             if let error = error {
                print("Unable to send data to firebase, network connection must be causing a problem ")
                return;
             }
             reference.downloadURL(completion: { (url, error) in
                 if let error = error {
                   print("Could not recieve the download URL network connection was interupted ")
                    return ;
                 }

                // okay this is where you post the url to Sukruth send this data to the backend and then Sukruth code can run off of it.
                print("this is the url: BRO : ",url!)

                var someDict = ["result":url!.absoluteString]
                self.makePOSTRequest(personDictionary: someDict)
                self.hideActivityIndicator()
                let alertView = SCLAlertView()
                for elem in self.foodValues{
                  alertView.addButton(elem) { ()-> Void in
                     self.correctFoods.append(elem)

                    }
                    print("This is the value in the button storage",self.correctFoods)
                }
              alertView.showSuccess("Food Options", subTitle: "Select the foods that apply to your dish")
                
                
                
//                 DispatchQueue.main.async {
//                 let appearance = SCLAlertView.SCLAppearance(
//                        showCloseButton: false // if you dont want the close button use false
//                    )
//                    let alertView = SCLAlertView(appearance: appearance)
//                alertView.addButton("Wood", backgroundColor: .blue, textColor: .red, showTimeout:nil, action: {() -> Void in
//                   self.dismiss(animated: true, completion: nil)
//                   })
              //  alertView.addButton(<#T##title: String##String#>, action: <#T##() -> Void#>)
               // alertView.addButton(<#T##title: String##String#>, target: <#T##AnyObject#>, selector: <#T##Selector#>)
              //  alertView.addObserver(<#T##observer: NSObject##NSObject#>, forKeyPath: <#T##String#>, options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutableRawPointer?#>)
                //alertView.addButton(<#T##title: String##String#>, backgroundColor: <#T##UIColor?#>, textColor: <#T##UIColor?#>, showTimeout: <#T##SCLButton.ShowTimeoutConfiguration?#>, target: <#T##AnyObject#>, selector: <#T##Selector#>)
//                    alertView.addButton("Ok Pressed") {
//                      self.correctFoods.append("food")
//                            print(self.correctFoods)
//                    }
//                    self.present(alertView, animated:true, completion:nil);
//                }
                print("the post request has finished hopefully")
                
             })
        })
        
        var apiImage = VisionImage(image: image);
        var labeler = Vision.vision().onDeviceImageLabeler();
        labeler.process(apiImage){ labels, error in
            guard error == nil , let labels = labels
                else {
                return
            }
            for label in labels{
                       let labelText = label.text;
                       let entityId = label.entityID;
                       let confidence = label.confidence;
                print(labelText);
            }
        }
        print("at the end of the sumbit button fucntion")
      }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
         (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait;
        let imageView = UIImageView(image: image)
        imageView.image = self.image
        imageView.frame = CGRect(x: 0, y: 0, width:view.frame.width, height: view.frame.height)
        imageView.contentMode = .scaleAspectFill
         view.addSubview(imageView)
        
        let approvalImage = UIImage(named: "checkbox") as UIImage?
        let submitButton = SqueezeButton(frame: CGRect(x:view.frame.width-50, y: 50, width: 50, height: 50))
        submitButton.setImage(approvalImage, for: .normal)
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        view.addSubview(submitButton)
        
        let trashImage = UIImage(named: "trashCan") as UIImage?
        let deleteButton = SqueezeButton(frame: CGRect(x:0, y: 50, width: 50, height: 50))
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        view.addSubview(deleteButton)
    }
}

   
