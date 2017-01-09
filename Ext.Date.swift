//
//  Extension.NSDate.swift
//  Lc
//
//  Created by Luciano Calderano on 09/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

enum DateFormat:String {
    case fmtDb      = "dd-MM-yyyy HH:mm"
    case fmtDbShort = "yyyy-MM-dd"
    case fmtData    = "dd/MM/yyyy"
    case fmtDataOra = "dd/MM/yyyy HH:mm"
}

import Foundation

extension String {
    func toDateFmt(_ fmt: DateFormat) -> Date {
        let df = DateFormatter()
        df.dateFormat = fmt.rawValue
        return df.date(from: self)!
    }
    func toDate(fmt: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = fmt
        return df.date(from: self)!
    }

    func dateConvert(fmtIn: String, fmtOut: String) -> String {
        let d = self.toDate(fmt: fmtIn)
        return d.toString(fmtOut)
    }
    func dateFmt(fmtIn: DateFormat, fmtOut: DateFormat) -> String {
        let d = self.toDate(fmt: fmtIn.rawValue)
        return d.toString(fmtOut.rawValue)
    }
}

extension Date {
    func toString(_ fmt: String) -> String {
        let df = DateFormatter()
        df.dateFormat = fmt
        return df.string(from: self)
    }
//    func fromString(_ date: String, fmt: String) -> Date {
//        let df = DateFormatter()
//        df.dateFormat = fmt
//        return df.date(from: date)!
//    }
//    
//    func dateConvert(_ fromFmt:String, toFmt:String) -> String {
//        let s = self.toString(fromFmt)
//        let d = Date().fromString(s, fmt: toFmt)
//        return d.toString(fromFmt)
//    }
//    
}
