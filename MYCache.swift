//
//  MYCache.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 09/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation
class MYCache {
    private static var myCachePath = ""
    
    init() {
        if (MYCache.myCachePath.isEmpty) {
            MYCache.myCachePath = NSTemporaryDirectory() + "MYCache/"
            self.cleanCache()
        }
    }
    
    class func getImageFromCache(_ url: String) -> Data? {
        return MYCache().getImageFromCache(url)
    }
    class func saveData(_ data:Data, url:String) {
        
    }
    private func getImageFromCache(_ url: String) -> Data? {
        let data: Data? = try? Data(contentsOf: self.filename(url))
        return data
    }
    
    private func saveData(_ data:Data, url:String) {
        do {
            try data.write(to: self.filename(url))
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func filename (_ url: String) -> URL {
        let array = url.components(separatedBy: "/")
        let file = MYCache.myCachePath + removeSpecialCharsFromString(array.last!)
        return URL.init(string:"file://" + file)!
    }
    
    private func removeSpecialCharsFromString(_ str: String) -> String {
        let chars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(str.characters.filter { chars.contains($0) })
    }
    
    private func cleanCache () {
        if UserDefaults.standard.bool(forKey: "settings.clearCache") == true {
            do {
                try FileManager.default.removeItem(atPath: MYCache.myCachePath)
            }
            catch {
            }
        }
        if (FileManager.default.fileExists(atPath: MYCache.myCachePath)) {
            self.cleanOldFiles()
        }
        else {
            do {
                try FileManager.default.createDirectory(atPath: MYCache.myCachePath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                NSLog("\(error.localizedDescription)")
            }
        }
    }
    
    private func cleanOldFiles() {
        let fm = FileManager.default
        do {
            let filePaths = try fm.contentsOfDirectory(atPath: MYCache.myCachePath)
            for filePath in filePaths {
                let fileName = MYCache.myCachePath + filePath
                let fileAttr = try fm.attributesOfItem(atPath: fileName)
                let fileDate = fileAttr[FileAttributeKey.creationDate] as? Date
                if self.daysBetweenDates(fileDate!, endDate: Date()) > 30 {
                    try fm.removeItem(atPath: fileName)
                }
            }
        } catch {
            print("Delete file error: \(error)")
        }
    }
    
    private func daysBetweenDates(_ startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
        return components.day!
    }
}

