//
//  MYHttp.swift
//  Lc
//
//  Created by Luciano Calderano on 07/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import Alamofire

//@objc class MYObjC_HttpRequest: NSObject {
//    func startBiz (page: String,
//                param: JsonDict,
//                completion: @escaping (Bool, JsonDict) -> () = { success, response in }) {
//        let request =  MYHttpRequest.pvt(page)
//        request.json = param
//        request.start() { (success, response) in
//            completion (success, response)
//        }
//    }
//    func startPvt (page: String,
//                param: JsonDict,
//                completion: @escaping (Bool, JsonDict) -> () = { success, response in }) {
//        let request =  MYHttpRequest.biz(page)
//        request.json = param
//        request.start() { (success, response) in
//            completion (success, response)
//        }
//    }
//}

class MYHttpRequest { // + custom extension in config.swift
    var json = JsonDict()
    
    private var page = ""
    private var auth = ""
    private var myWheel:MYWheel?
    private var parameters: JsonDict {
        get {
            var parameters = self.json
            parameters["auth_code"] = self.auth
            return parameters
        }
    }

    init(auth: String, page: String) {
        self.page = page
        self.auth = auth
    }
    

//    init(_ httpConfig: Array<String>, page: String) {
//        self.page = httpConfig[0] + page
//        self.auth = httpConfig[1]
//    }
    
    // MARK: - Start
    
    func start (showWheel: Bool = true, completion: @escaping (Bool, JsonDict) -> () = { success, response in }) {
        self.startWheel(true, show: showWheel)
        self.printJson(self.json)
        Alamofire.request(self.page, method: .post, parameters: self.parameters).responseJSON { response in
            completion (response.result.isSuccess, response.result.value as! JsonDict)
            self.startWheel(false)
            self.printJson(response.result.value as! JsonDict)
        }
    }
    
    // MARK: - private
    
    private func printJson (_ json: JsonDict) {
        if MYHttpRequest.printJson {
            print("\n[ \(self.page) ]\n\(json)\n------------")
        }
    }
    
    private func startWheel(_ start: Bool, show: Bool = true, inView: UIView = UIApplication.shared.keyWindow!) {
        guard show else {
            return
        }
        if start {
            self.myWheel = MYWheel()
            self.myWheel?.start(inView)
        }
        else {
            self.myWheel?.stop()
            self.myWheel = nil
        }
    }
    
}

