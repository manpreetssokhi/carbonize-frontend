//
//  InfoViewController.swift
//  cWatch
//
//  Created by Ali on 2/21/20.
//  Copyright © 2020 Ali. All rights reserved.
//
import UIKit
import Foundation
class infoViewController:UIViewController{
    @IBOutlet weak var chartView: chartViewController!
    func titleLabel(yParam:Int,width:Int, title: String , Size: Float){
              let label1 = UILabel(frame: CGRect(x: 25, y: yParam, width: width, height: 100))
              label1.textAlignment = .center
              label1.lineBreakMode = NSLineBreakMode.byWordWrapping
              label1.numberOfLines = 2
              label1.text=title;
              label1.textColor = .white;
              label1.font = UIFont.systemFont(ofSize: CGFloat(Size))
                     self.view.addSubview(label1)
             }
    func titleLabel2(yParam:Int,width:Int, title: String , Size: Float){
                 let label1 = UILabel(frame: CGRect(x: 25, y: yParam, width: width, height: 100))
                 label1.textAlignment = .left
                 label1.lineBreakMode = NSLineBreakMode.byWordWrapping
                 label1.numberOfLines = 2
                 label1.text=title;
                 label1.textColor = .white;
                 label1.font = UIFont.systemFont(ofSize: CGFloat(Size))
                        self.view.addSubview(label1)
                }
    func titleLabel3(xParam:Int,yParam:Int,width:Int, title: String , Size: Float){
                    let label1 = UILabel(frame: CGRect(x: xParam, y: yParam, width: width, height: 100))
                    label1.textAlignment = .left
                    label1.lineBreakMode = NSLineBreakMode.byWordWrapping
                    label1.numberOfLines = 2
                    label1.text=title;
                    label1.textColor = .white;
                    label1.font = UIFont.systemFont(ofSize: CGFloat(Size))
                           self.view.addSubview(label1)
                   }
       
       
       func infoLabel(yParam:Int,width:Int, title: String , Size: Float){
          let label1 = UILabel(frame: CGRect(x: 20, y: yParam, width: width, height: 100))
          label1.textAlignment = .center
          label1.lineBreakMode = NSLineBreakMode.byWordWrapping
          label1.numberOfLines = 2
          label1.text=title;
         label1.attributedText=NSAttributedString(string: title,attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]);
          label1.textColor = .white;
          label1.font = UIFont.systemFont(ofSize: CGFloat(Size))
                 self.view.addSubview(label1)
         }
    
     func infoLabel2(yParam:Int,width:Int, title: String , Size: Float){
              let label1 = UILabel(frame: CGRect(x: 25, y: yParam, width: width, height: 100))
              label1.textAlignment = .center
              label1.lineBreakMode = NSLineBreakMode.byWordWrapping
              label1.numberOfLines = 2
              label1.text=title;
             label1.attributedText=NSAttributedString(string: title,attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]);
              label1.textColor = .white;
              label1.font = UIFont.systemFont(ofSize: CGFloat(Size))
                     self.view.addSubview(label1)
             }
        
    
    
    
    
    @IBAction func displayChart(_ sender: UIButton) {
        chartViewController.playAnimation();
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        print("it got here at least");
        var languages = [String]()
        languages.append("-> Incorporate more plant-based proteins and less red meat in your diet");
        languages.append("-> Source your groceries from local producers and farmers’ markets");
        languages.append("-> Try to buy and use organic produce when possible");
        languages.append("-> Reduce food waste and compost all food scraps");
        languages.append("-> Utilize public transport or carpool to reach your workplace tomorrow");
        languages.append("-> Minimize household energy consumption - be cognizant about water usage or turn down the heater by a degree");
        
        let randomName = languages.randomElement()
        var randomName2 = languages.randomElement()
        while(randomName == randomName2){
         randomName2 = languages.randomElement();
        }
        
        print(randomName!);
        print(randomName2!);
        infoLabel2(yParam: 350, width: 350, title: "Your Results", Size: 19)
        titleLabel2(yParam: 400, width: 350, title: "Your Carbon Index Score:", Size: 17);
        titleLabel3(xParam: 250 ,yParam: 400, width: 350, title: "60", Size: 17);
        infoLabel(yParam: 450, width: 350, title: "Tips to Improve Your Carbon FootPrint ", Size: 19)
        titleLabel(yParam: 510, width: 350, title: randomName!, Size: 17);
        titleLabel(yParam: 580, width: 350, title: randomName2!, Size: 17);

 
        chartView.contentMode = .scaleAspectFit;
     }
    

}
