//
//  loginInPage.swift
//  cWatch
//
//  Created by Ali on 2/21/20.
//  Copyright © 2020 Ali. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation
import SpriteKit
class loginInPage: UIViewController {
    
    @IBOutlet var screenView: UIView!
    var activityView: UIActivityIndicatorView?

    func showActivityIndicator() {
          activityView = UIActivityIndicatorView(style: .whiteLarge)
          activityView?.color = .black;
          activityView?.center = self.view.center
          self.view.addSubview(activityView!)
          activityView?.startAnimating()
      }
      

      func hideActivityIndicator(){
          if (activityView != nil){
              activityView?.stopAnimating()
          }
      }
    
    @IBOutlet weak var label: UILabel!

    func titleLabel(yParam:Int,width:Int, title: String , Size: Float){
           let label1 = UILabel(frame: CGRect(x:27, y: yParam, width: width, height: 100))
           label1.textAlignment = .center
           label1.lineBreakMode = NSLineBreakMode.byWordWrapping
           label1.numberOfLines = 2
           label1.textColor = .white;
           label1.text=title;
           label1.font = UIFont.systemFont(ofSize: CGFloat(Size))
          
                  self.view.addSubview(label1)
          }
    
    
    func infoLabel(yParam:Int,width:Int, title: String , Size: Float){
       let label1 = UILabel(frame: CGRect(x: 25, y: yParam, width: width, height: 100))
       label1.textAlignment = .center
       label1.lineBreakMode = NSLineBreakMode.byWordWrapping
       label1.numberOfLines = 2
       label1.text=title;
       label1.textColor = .white;
       label1.alpha = 1;// this was added as new info
       label1.font = UIFont.systemFont(ofSize: CGFloat(Size))
       label1.highlightedTextColor = .green;
              self.view.addSubview(label1)
      }

    override func viewDidLoad() {
    super.viewDidLoad()
         (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait;
     
     //let screenWidth = screenView.bounds.width
        print("this is the frame measurments: ",view.frame)
    
     let sHeight = view.frame.height-83;
     //   let realHeight = view.frame.height;
     let sWidth = view.frame.width;// this gives me the lenght of
     //   let firstCal = sHeight/2;// this is the length that will be
        
        
        let view1 = UIImageView(frame: CGRect(x: 0 , y:100 , width: 375 , height: 600))
                   view1.backgroundColor = UIColor.magenta
                   view1.layer.borderWidth = 0.5
                   view1.image = UIImage(named:"trashCan2")
                   view1.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(view1)
        
     print("this is the height the screen: ", sHeight);
     print("this is the with the screen: ", sWidth);
        view.backgroundColor = UIColor.black;

        titleLabel(yParam: 140, width: 300, title: "Welcome To Carbonize",Size: 30)
        infoLabel(yParam: 600, width: 300, title: "Slide right to take a picture >>",Size: 15)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        
        view.addGestureRecognizer(leftSwipe);
    }
    @objc func handleSwipe(sender:UISwipeGestureRecognizer){
                    if(sender.state == .ended){
                        print("i got here");
            performSegue(withIdentifier: "loginSign", sender: nil)

                    }
                }
}
