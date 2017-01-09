//
//  MYCache.swift
//
//  Created by Luciano Calderano on 09/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation
class MYCache {
    
    static let sharedInstance = MYCache()
    
    func imageFromUrl(_ url: String) -> Data? {
        let data: Data? = try? Data(contentsOf: self.urlToFileName(url))
        return data
    }
    
    func saveImageWithData(_ data:Data, url:String) {
        do {
            try data.write(to: self.urlToFileName(url))
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: private
    
    private let myPathCache = NSTemporaryDirectory() + "MYCache/"
    private let charSet = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
    private let settingsKey = "settings.clearCache"
    
    private init() {
        self.cleanCache()
    }
    
    private func urlToFileName (_ url: String) -> URL {
        let array = url.components(separatedBy: "/")
        let file = String(array.last!.characters.filter { charSet.contains($0) })
        return URL.init(string:"file://" + MYCache.sharedInstance.myPathCache + file)!
    }
    
    private func cleanCache () {
        if UserDefaults.standard.bool(forKey: self.settingsKey) == true {
            do {
                try FileManager.default.removeItem(atPath: self.myPathCache)
            }
            catch {
            }
        }
        if (FileManager.default.fileExists(atPath: self.myPathCache)) {
            self.removeOldFiles()
        }
        else {
            do {
                try FileManager.default.createDirectory(atPath: self.myPathCache,
                                                        withIntermediateDirectories: false,
                                                        attributes: nil)
            } catch let error as NSError {
                NSLog("\(error.localizedDescription)")
            }
        }
    }
    
    private func removeOldFiles() {
        let fm = FileManager.default
        do {
            let filePaths = try fm.contentsOfDirectory(atPath: self.myPathCache)
            for filePath in filePaths {
                let fileName = self.myPathCache + filePath
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

