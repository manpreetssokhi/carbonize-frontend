//
//  chartViewController.swift
//  cWatch
//
//  Created by Ali on 2/21/20.
//  Copyright © 2020 Ali. All rights reserved.
//
import Foundation
import Macaw
import UIKit
class chartViewController: MacawView{
    
static let lastSixShots = data();
/**   A few things to note .with(a: 0.25) is a value that represents how clear the color will appear .10 is very low
     
     */
// max number of times i belive is 10 or 11 max for sure 9 is already seems to only have space for one more item
private static func data() -> [chartData]{
       let one = chartData(chartValue: "Heavy \n Meat", viewCount: 50*5);
       let two = chartData(chartValue: "Light \n Meat", viewCount:  0*5);
       let three = chartData(chartValue: "Veggies",viewCount:      15*5);
       let four = chartData(chartValue: "Fruit", viewCount:         0*5);
       let five = chartData(chartValue: "Grains", viewCount:       20*5);
       let six = chartData(chartValue: "Dairy", viewCount:         10*5);
       let seven = chartData(chartValue: "Sweets", viewCount:       0*5);
       let eight = chartData(chartValue: "Nuts", viewCount:         0*5);
       let nine = chartData(chartValue: "Other", viewCount:         0*5);
       return [one , two , three , four , five , six , seven , eight , nine ];
   }
    // max value number must be divisable by the let maxLines in addYAxisItems function
    
    
static let maxValue = 100; // this is the highest value that will be displayed on the left of the graph
static let maxValueLineHeight = 100; //180 // i dont fully understand what this does it, but it controlls the size of the bar columns on the graph
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
        let yAxisHeight: Double = 100 // how long the yaxis line is
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
        let yAxis = Line(x1: 0, y1: -400, x2: 0 , y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
        // x1: should always be 0 !! // needs to match x2(if negative value it pulls toward the right and postive to the left)
        // y1: should be the negative version of xAxisHeight/2
        // x2: should always be 0 !! // needs to match x1(if negative value it pulls toward the right and postive to the left)
        // y2: should always be the yAxisHeight
        newNodes.append(yAxis);
        
        return newNodes;
    }
    
    
    private static func addXAxisItems() -> [Node]{
         print("it got to the XAXIS Item");
        let chartBaseY : Double = 100 // this value should be equal to the yAxisHeight value
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
            
            let rect = Rect(x: Double(i)*50+30, y: 100-height , w: 30, h: height)// was 30 for the width //was  +25 for the x:
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




// next step is how to make pie charts using macaw in
