//
//  trashCode.swift
//  cWatch
//
//  Created by Ali on 2/25/20.
//  Copyright © 2020 Ali. All rights reserved.
//

import Foundation
//    func makePOSTRequest(personDictionary: Dictionary<String,String>)->Bool{
//        dispatchGroup.enter();
//        guard let uploadData = try? JSONEncoder().encode(personDictionary) else{// this lets know if the dictionary is properly json encoded or allowed to be encoded
//            print("it hit a problem in the first if check");
//            return result;
//        }
//        print(uploadData)
//        let url = URL(string: "https://carbonize.herokuapp.com/POST/rawImage")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        print(thread_info_t.self);
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
//        print("it got herer ");
//        request.httpBody = try? JSONSerialization.data(withJSONObject: personDictionary, options: .prettyPrinted)
//        let task = URLSession.shared.uploadTask(with: request, from: uploadData){ (data, response, error) in
//            if let error = error{
//                print("error this is the responce : \(error)");
//                self.result=false;
//                return ;
//            }
//
//            let response = response as? HTTPURLResponse;
//            print("this the responce from the back end :", response);
//            let resType=response!.mimeType;
//
//            print("this is the responce type: ",resType as Any);
//            if(resType != "application/json"){
//                print("invalid data has been sent over from the back end");
//            }
//
//            if let mimeType = response!.mimeType,
//                mimeType == "application/json",// explain what content type we are dealing with
//                let data = data,
//                let dataString = String(data:data, encoding: .utf8){
//                print("it got herer ");
//                print("got data: \(dataString)")
//                self.result = true;
//                print("first leave within post")
//                self.dispatchGroup.leave();
//            }
//        }
//
//        task.resume();
//        dispatchGroup.wait();
//        return result;
//    }
//    func nsdataToJSON(data: NSData) -> AnyObject? {
//        do {
//            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil
//    }
//
//
//    func makePOSTRequest(personDictionary:Any) {
//           print("first enter within post")
//           dispatchGroup.enter()
//
//
//               print(JSONSerialization.isValidJSONObject(personDictionary))
//           //   guard let uploadData = try? JSONEncoder().encode(personDictionary) else{
//        guard let uploadData = try? personDictionary else{
//                   return
//               }
//                   print(uploadData)
//                   let url = URL(string: "https://carbonize.herokuapp.com/POST/rawImage")!
//                   var request = URLRequest(url: url)
//                   request.httpMethod = "POST"
//                   request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let task = URLSession.shared.uploadTask(with: request, from: uploadData as? Data) { data, response, error in
//                   if let error = error{
//                       print("error: \(error)")
//                       return
//                   }
//                   let response = response as? HTTPURLResponse
//                   if let mimeType = response!.mimeType,
//                   mimeType == "application/json",
//                   let data = data,
//                       let dataString = String(data:data, encoding: .utf8){
//                       print("got data: \(dataString)")
//                       self.idAppendedToGet = dataString
//                       print("first leave within post")
//                       self.dispatchGroup.leave()
//                   }
//               }
//               task.resume()
//           dispatchGroup.wait()
//           print("this is our id right after the post method closure\(idAppendedToGet)")
//       }

//
//  chartViewController.swift
//  cWatch
//
//  Created by Ali on 2/21/20.
//  Copyright © 2020 Ali. All rights reserved.
//
/*
import Foundation
import Macaw
import UIKit
class chartViewController: MacawView{
    
static let lastSixShots = data();
/**   A few things to note .with(a: 0.25) is a value that represents how clear the color will appear .10 is very low
     
     
     */
// max number of times i belive is 10 or 11 max for sure 9 is already seems to only have space for one more item
private static func data() -> [chartData]{
       let one = chartData(chartValue: "Heavy \n Meat", viewCount: 400);
       let two = chartData(chartValue: "Light \n Meat", viewCount: 375);
       let three = chartData(chartValue: "Veggies",viewCount:      300);
       let four = chartData(chartValue: "Fruit", viewCount:        150);
       let five = chartData(chartValue: "Grains", viewCount:       200);
       let six = chartData(chartValue: "Dairy", viewCount:         100);
       let seven = chartData(chartValue: "Sweets", viewCount:      450);
       let eight = chartData(chartValue: "Nuts", viewCount:        500);
       let nine = chartData(chartValue: "Other", viewCount:        200);
       return [one , two , three , four , five , six , seven , eight , nine ];
   }
    // max value number must be divisable by the let maxLines in addYAxisItems function
    
    
static let maxValue = 500; // this is the highest value that will be displayed on the left of the graph
static let maxValueLineHeight = 500; //180 // i dont fully understand what this does it, but it controlls the size of the bar columns on the graph
static let lineWidth: Double = 275; // this controlls the line length across the width of the screen
static let dataDivisor = Double(maxValue/maxValueLineHeight);
    
    
static let adjustData: [Double] = lastSixShots.map({ $0.viewCount / dataDivisor }) //
static var animations: [Animation] = []; //
    
    required init?(coder aDecoder: NSCoder){
          print("it got to the decoder ");
         super.init(node: chartViewController.createChart() , coder: aDecoder)
         backgroundColor = .clear
     }
    struct chartData {
    var chartValue: String; //
    var viewCount: Double; //
    }

    
    private static func createChart() -> Group {
        
        var items:[Node] = addYAxisItems() + addXAxisItems();
        items.append(createBars());
        return Group(contents: items ,place: .identity );
    }
    
    private static func addYAxisItems ()-> [Node]{
        let maxLines = 10;// this number represents the number of divsions in th bar graphs x axis
        let lineIntervals = Int(maxValue/maxLines);
        let yAxisHeight: Double = 500 // how long the yaxis line is
        let lineSpacing: Double = 50// how much space is inbetween each of the lines in the yaxis
        
        var newNodes: [Node] = []
        
        for i in 0...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing) // this calculates the postion of the all the y axis lines so it will dirstubute is across the screen properly and porpotinally
            let valueLine = Line(x1: 0, y1: y, x2: lineWidth+190, y2: y).stroke(fill: Color.white.with(a: 0.15))
            // Line(x1: spacing that the x axis has with the y at the intial start -5 to make it hit the y-axis
                                 //y1: must be the same as y2 baically tell the y axis where to start
                                 //x2:
                                 //y2: must be the same as y1 bascially tells where the yaxis line should end at
            let valueText = Text(text: " \(i*lineIntervals) ", align: .max, baseline: .mid, place: .move(dx: -10, dy: y) )
       
            
            valueText.fill = Color.white;
            newNodes.append(valueLine);
            newNodes.append(valueText);
        }
        // y1: will be the
        let yAxis = Line(x1: 0, y1: 0, x2: 0 , y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
        // x1: should always be 0 !! // needs to match x2(if negative value it pulls toward the right and postive to the left)
        // y1: should be the negative version of xAxisHeight/2
        // x2: should always be 0 !! // needs to match x1(if negative value it pulls toward the right and postive to the left)
        // y2: should always be the yAxisHeight
        newNodes.append(yAxis);
        
        return newNodes;
    }
    
    
    private static func addXAxisItems() -> [Node]{
         print("it got to the XAXIS Item");
        let chartBaseY : Double = 500 // this value should be equal to the yAxisHeight value
        var newNodes : [Node] = []
        for i in 1...adjustData.count {
            
                   let x = (Double(i) * 50) // this thing
            let valueText = Text(text:(lastSixShots[i - 1].chartValue), align: .mid , baseline: .bottom, place: .move(dx: x-5, dy: chartBaseY + 20) )// 20
                 // text:
                 // aligin: .max | .mid | .min
                 // baseline: .bottom(makes the x axis value display right next to the line) | .mid | .top(further away)
                 // place:
            
                   valueText.fill = Color.white;
                   newNodes.append(valueText);
               }
               let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth+190, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        
                  // x1: must be 0 to match up with the y-axis origin postion
                  // y1: must be the same number as the chartBaseY value
                  // x2: this is the length of the x-axis line will appear across the users screen
                  // y2: must be the same number as the chartBaseY aka same value of y1 to
                  // stroke fill: color of the x-axis line
                  // a: is how visable that line will appear
        
               newNodes.append(xAxis);
        return newNodes;
          
      }
    
    //FF3333 red
    //3396FF light blue
    private static func createBars() -> Group {
         var fill = LinearGradient(degree: 90, from: Color.init(val: 0x3396FF), to: Color(val:0x58FF33 ).with(a: 0.33))
        // degree: could be any value from 0 - 10000 changes the degree of the color visual
        // from: the starting color
        // to: the ending color
        // with(a:0.33) the amount of visablity of the color
      
        let items = adjustData.map { _ in Group() }
        animations = items.enumerated().map{(i:Int,item:Group) in item.contentsVar.animation(delay:Double(i)*0.2){ t in
            let height = adjustData[i] * t;// look at this later
            
            let rect = Rect(x: Double(i)*50+30, y: 500-height , w: 30, h: height)// was 30 for the width //was  +25 for the x:
            // x:
            // y: this value should always be the same as the chartBaseY value - height
            // w: this is the size/ width of  each of columns in the graph
            // h:

             
            return [rect.fill(with: fill)];
            }
        }
      return items.group();
}

    static func playAnimation(){
        animations.combine().play();
    }
    
}

// things to find out
// what does "\ (blavh sfdsf )" do
*/
//
//  carbonizeSlideViewController.swift
//  cWatch
//
//  Created by Ali on 2/27/20.
//  Copyright © 2020 Ali. All rights reserved.
//

//import Foundation
//import UIKit
//class carbonizeSlideViewController: UIViewController {
//
//
//
//    private var scrollView: UIScrollView!
//
//              override func viewDidLoad() {
//                  super.viewDidLoad()
//                  setupUI()
//              }
//
//              private func setupUI() {
//                  let rightPanel = infoViewController()
//                  let centerPanel = ViewController()
//                  let leftPanel = loginInPage()
//
//                  scrollView = UIScrollView.makeHorizontal(
//                      with: [loginInPage, ViewController, infoViewController],
//                      in: self
//                  )
//                  view.addSubview(scrollView)
//                  scrollView.fit(to: view)
//              }
//
//}
//
//  extension UIScrollView {
//        //1
//        fileprivate static func make() -> UIScrollView {
//            let scrollView = UIScrollView()
//            scrollView.backgroundColor = .clear
//            scrollView.isPagingEnabled = true
//            scrollView.bounces = false
//            scrollView.showsHorizontalScrollIndicator = false
//            scrollView.showsVerticalScrollIndicator = false
//            return scrollView
//        }
//
//        static func makeHorizontal(with horizontalControllers: [UIViewController], in parent: UIViewController) -> UIScrollView {
//            let scrollView = UIScrollView.make();
//            //2
//            func add(_ child: UIViewController, withOffset offset: CGFloat) {
//                parent.addChild(child)
//                scrollView.addSubview(child.view)
//                child.didMove(toParent: parent)
//                child.view.translatesAutoresizingMaskIntoConstraints = false
//                NSLayoutConstraint.activate([
//                    child.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//                    child.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
//                    child.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: offset)
//                    ])
//            }
//
//            //3
//            let width = UIScreen.main.bounds.width
//            let height = UIScreen.main.bounds.height
//
//            //4
//            for (index, controller) in horizontalControllers.enumerated() {
//                let xPosition = CGFloat(index) * width
//                add(controller, withOffset: xPosition)
//            }
//
//            //5
//            scrollView.contentSize = CGSize(width: width * CGFloat(horizontalControllers.count), height: height)
//            scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
//
//            return scrollView
//        }
//    }
//
//
//extension UIView {
//    func fit(to container: UIView) {
//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: container.leadingAnchor),
//            trailingAnchor.constraint(equalTo: container.trailingAnchor),
//            topAnchor.constraint(equalTo: container.topAnchor),
//            bottomAnchor.constraint(equalTo: container.bottomAnchor)
//            ])
//    }
//}
//        var apiImage = VisionImage(image: image);
//        var labeler = Vision.vision().onDeviceImageLabeler();
//        labeler.process(apiImage){ labels, error in
//            guard error == nil , let labels = labels
//                else {
//                return
//            }
//            for label in labels{
//                       let labelText = label.text;
//                       let entityId = label.entityID;
//                       let confidence = label.confidence;
//                print(labelText);
//                //print(entityId);
//                //print(confidence);
//                   }
//
//
//        }


    
//    func makePOSTRequest(personDictionary: Dictionary<String,String>){
//       // displayLoader();
//        print("first enter within post")
//        dispatchGroup.enter();
//
//        guard let uploadData = try? JSONEncoder().encode(personDictionary) else{// this lets know if the dictionary is properly json encoded or allowed to be encoded
//            print("it hit a problem in the first if check");
//            return ;
//        }
//        print(uploadData)
//        //https://still-ocean-94761.herokuapp.com/producer
//       // https://still-ocean-94761.herokuapp.com/producer
//        let url = URL(string: "https://still-ocean-94761.herokuapp.com/producer")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        print(thread_info_t.self);
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
//        print("it got herer ");
//        request.httpBody = try? JSONSerialization.data(withJSONObject: personDictionary, options: .prettyPrinted)
//        let task = URLSession.shared.uploadTask(with: request, from: uploadData){ (data, response, error) in
//            if let error = error{
//                print("error this is the responce : \(error)");
//               // self.result=false;
//                return ;
//            }
//
//            let response = response as? HTTPURLResponse;
//
//            let resType=response!.mimeType;
//
//            print("this is the responce type: ",resType as Any);
////            if(resType != "application/json"){
////                print("invalid data has been sent over from the back end");
////            }
//
//            if let mimeType = response!.mimeType,
//                mimeType == "application/json",// explain what content type we are dealing with
//                let data = data,
//                let dataString = String(data:data, encoding: .utf8){
//                print("it got herer ");
//                print("got data: \(dataString)")
//              //  self.result = true;
//                print("first leave within post")
//                self.dispatchGroup.leave();
//            }
//        }
//
//        task.resume();
//        dispatchGroup.wait();
//
//    }
    
