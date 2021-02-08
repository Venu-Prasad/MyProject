//
//  VideoCrop.swift
//  demo
//
//  Created by venu on 2/3/21.
//  Copyright © 2021 Z. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func processVideo(videoUrl:NSURL) {
        
        let trfVideoFile = self.getShakeResultsFilePath() ?? ""
        let croppedVideoFile = self.getCroppedVideoPath() ?? ""
        let originalVideoFile = videoUrl.path ?? ""

        
        let cropCommand = "-i \(originalVideoFile) -vf crop=0.70*in_w:0.70*in_h -r 3 -an -vcodec libx264 -profile:v high -y \(croppedVideoFile)"
        MobileFFmpeg.execute(cropCommand)
        
        let stabilizeCommand = "-hide_banner -y -i \(croppedVideoFile) -vf vidstabdetect=shakiness=10:accuracy=15:result=\(trfVideoFile) -f null -"
        MobileFFmpeg.execute(stabilizeCommand)

        let exportFrameCommand = "-i \(croppedVideoFile) -vf vidstabtransform=input=\(trfVideoFile):zoom=1:smoothing=10 -r 3 \(outputPath() ?? "")"
        MobileFFmpeg.execute(exportFrameCommand)
        
    }
    
    func outputPath() -> String? {
        
        
        let uuid = UUID().uuidString
        let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]
    
        var dirPath = ""
        
         dirPath = String(format: "%@/360_IMAGES/%@", docFolder,uuid)

        do
        {
            try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        dirPath = dirPath.appendingFormat("/%@%@", uuid,"_%d.jpeg")
        
        print(dirPath)
        
        return dirPath
    }

    
    func getShakeResultsFilePath() -> String? {
        let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]
        return URL(fileURLWithPath: docFolder).appendingPathComponent("transforms.trf").path
    }

    func getVideoPath() -> String? {
        let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]
        return URL(fileURLWithPath: docFolder).appendingPathComponent("video.mp4").path
    }

    func getCroppedVideoPath() -> String? {
        let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]
        return URL(fileURLWithPath: docFolder).appendingPathComponent("croppedVideo.mp4").path
    }

    func getStabilizedVideoPath() -> String? {
        let docFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]
        return URL(fileURLWithPath: docFolder).appendingPathComponent("video-stabilized.mp4").path
    }
    
}
