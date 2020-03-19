//
//  imageSavefr.swift
//  cWatch
//
//  Created by Ali on 2/25/20.
//  Copyright © 2020 Ali. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI
import Firebase
import UserNotifications
import AVFoundation
import SwiftyJSON

class imageSaver: NSObject {
       func writeToPhotoAlbum(image: UIImage) {
           UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
       }

       @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           print("Save finished!")
       }
   }
