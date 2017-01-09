//
//  MYHttp.swift
//  Lc
//
//  Created by Luciano Calderano on 07/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import Alamofire

var urlAllowed = CharacterSet()

class MY_HttpRequest {
    var viewForWheel = UIApplication.shared.keyWindow!
    var json = JsonDict()
    
    private var page = ""
    private var auth = ""
    private var myWheel:MYWheel?
    
    init(_ httpConfig: Array<String>, page: String) {
        self.page = httpConfig[0] + page
        self.auth = httpConfig[1]
    }
    
    // MARK: - Start
    
    private func parameters () -> JsonDict {
        var parameters = self.json
        parameters["auth_code"] = self.auth
        return parameters
    }
    
    func start (showWheel: Bool = true, completion: @escaping (Bool, JsonDict) -> () = { success, response in }) {
        self.startWheel(true, show: showWheel)
        self.printJson(self.json)
        
                let task = URLSession.shared.dataTask(with: self.urlRequest()) { (data, response, error) in
                    DispatchQueue.main.async {
                        let resp = self.checkResponse(data, error: error as NSError?)
                        completion (resp.success, resp.json)
                        self.startWheel(false)
                        self.printJson(resp.json)
                    }
                }
                task.resume()
    }
    
    // MARK: - private
    
    private func printJson (_ json: JsonDict) {
        if MYHttpRequest.printJson {
            print("\n[ \(self.page) ]\n\(json)\n------------")
        }
    }
    
    private func startWheel(_ start: Bool, show: Bool = true) {
        guard show else {
            return
        }
        if start {
            self.myWheel = MYWheel()
            self.myWheel?.start(self.viewForWheel)
        }
        else {
            self.myWheel?.stop()
            self.myWheel = nil
        }
    }
    
        private func urlRequest() -> URLRequest{
            var request = URLRequest(url: URL(string: self.page)!)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = self.jsonBody()
            return request
        }
    
        private func jsonBody() -> Data {
            func encode (_ string: String) -> String {
                if urlAllowed.isEmpty {
                    urlAllowed = CharacterSet.urlQueryAllowed
                    urlAllowed.remove(charactersIn: ":#[]@!$&'()*+,;=")
                }
                return string.addingPercentEncoding(withAllowedCharacters: urlAllowed)!
            }
            var jsonString = ""
            for (key, value) in self.json {
                jsonString += encode(key) + "=" + encode(String(describing: value)) + "&"
            }
            jsonString += "auth_code" + "=" + encode(self.auth)
            return jsonString.data(using: String.Encoding.utf8)!
        }
    
        private func checkResponse (_ data: Data?, error: NSError?) -> (success: Bool, json: JsonDict) {
            var json = JsonDict()
            guard error == nil && data != nil else {
                self.showAlert("Data error!", message: error!.localizedDescription as String)
                return (false, json)
            }
    
            json = self.jsonDataToDict(data!)
            guard json.count > 0 else {
                self.showAlert("Json error!", message: "")
                return (false, json)
            }
            return (true, json)
        }
    
        private func jsonDataToDict(_ data: Data) -> JsonDict {
            var json = JsonDict()
            do {
                json = try JSONSerialization.jsonObject(with: data, options: []) as! JsonDict
            }
            catch {
                print("Json error")
            }
            return json
        }
    
    private func showAlert (_ title:String, message: String) {
        let alert = UIAlertController(title: title as String, message: message  as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let ctrl = UIApplication.shared.keyWindow?.rootViewController
        ctrl!.present(alert, animated: true, completion: nil)
    }
}

