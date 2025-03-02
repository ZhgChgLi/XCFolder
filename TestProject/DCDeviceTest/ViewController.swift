//
//  ViewController.swift
//  DCDeviceTest
//
//  Created by 李仲澄 on 2019/4/29.
//  Copyright © 2019 ZhgChgLi. All rights reserved.
//

import UIKit
import DeviceCheck
import CupertinoJWT

extension String {
    var queryEncode:String {
        return self.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines)?.replacingOccurrences(of: "+", with: "%2B") ?? ""
    }
}
class ViewController: UIViewController {

    
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    @IBAction func getBtnClick(_ sender: Any) {
        DCDevice.current.generateToken { dataOrNil, errorOrNil in
            guard let data = dataOrNil else { return }
            
            let deviceToken = data.base64EncodedString()
            
            //正式情況：
            //POST deviceToken 到後端，請後端去跟蘋果伺服器查詢，然後再回傳結果給APP處理
            
            
            //!!!!!!以下僅為測試、示範所需，不建議用於正式環境!!!!!!
            //!!!!!!      請勿隨意暴露您的PRIVATE KEY    !!!!!!
                let p8 = """
                    -----BEGIN PRIVATE KEY-----
                    -----END PRIVATE KEY-----
                    """
                let keyID = "" //你的KEY ID
                let teamID = "" //你的Developer Team ID :https://developer.apple.com/account/#/membership
            
                let jwt = JWT(keyID: keyID, teamID: teamID, issueDate: Date(), expireDuration: 60 * 60)
            
                do {
                    let token = try jwt.sign(with: p8)
                    var request = URLRequest(url: URL(string: "https://api.devicecheck.apple.com/v1/update_two_bits")!)
                    request.httpMethod = "POST"
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    let json:[String : Any] = ["device_token":deviceToken,"transaction_id":UUID().uuidString,"timestamp":Int(Date().timeIntervalSince1970.rounded()) * 1000,"bit0":true,"bit1":false]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        guard let data = data else {
                            return
                        }
                        print(String(data:data, encoding: String.Encoding.utf8))
                        DispatchQueue.main.async {
                            self.getBtn.isHidden = true
                            self.statusBtn.isSelected = true
                        }
                    }
                    task.resume()
                } catch {
                    // Handle error
                }
            //!!!!!!以上僅為測試、示範所需，不建議用於正式環境!!!!!!
            //
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DCDevice.current.generateToken { dataOrNil, errorOrNil in
            guard let data = dataOrNil else { return }
            
            let deviceToken = data.base64EncodedString()
            
            //正式情況：
                //POST deviceToken 到後端，請後端去跟蘋果伺服器查詢，然後再回傳結果給APP處理
            
            
            //!!!!!!以下僅為測試、示範所需，不建議用於正式環境!!!!!!
            //!!!!!!      請勿隨意暴露您的PRIVATE KEY    !!!!!!
                let p8 = """
                -----BEGIN PRIVATE KEY-----
                
                -----END PRIVATE KEY-----
                """
                let keyID = "" //你的KEY ID
                let teamID = "" //你的Developer Team ID :https://developer.apple.com/account/#/membership
            
                let jwt = JWT(keyID: keyID, teamID: teamID, issueDate: Date(), expireDuration: 60 * 60)
            
                do {
                    let token = try jwt.sign(with: p8)
                    var request = URLRequest(url: URL(string: "https://api.devicecheck.apple.com/v1/query_two_bits")!)
                    request.httpMethod = "POST"
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    let json:[String : Any] = ["device_token":deviceToken,"transaction_id":UUID().uuidString,"timestamp":Int(Date().timeIntervalSince1970.rounded()) * 1000]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        guard let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any],let stauts = json["bit0"] as? Int else {
                            return
                        }
                        print(json)
                        
                        if stauts == 1 {
                            DispatchQueue.main.async {
                                self.getBtn.isHidden = true
                                self.statusBtn.isSelected = true
                            }
                        }
                    }
                    task.resume()
                } catch {
                    // Handle error
                }
            //!!!!!!以上僅為測試、示範所需，不建議用於正式環境!!!!!!
            //
            
        }
        // Do any additional setup after loading the view.
    }


}

