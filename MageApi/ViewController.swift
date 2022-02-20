//
//  ViewController.swift
//  MageApi
//
//  Created by suandrew on 2/19/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var nutritionTxt: UILabel!
    
    @IBOutlet weak var carbsTxt: UITextField!
    @IBOutlet weak var proteinTxt: UITextField!
    @IBOutlet weak var fatTxt: UITextField!
    @IBOutlet weak var electrolyteTxt: UITextField!
    @IBOutlet weak var vitaminTxt: UITextField!
    @IBOutlet weak var caloriesTxt: UITextField!
    @IBOutlet weak var wellnessTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        predictionTxt.text = "Hit the Prediction Button"
    }

    let api_key = "ilOxOhT4aZNgJ9XteGWyeKa3hpnQ2hZggna3Ucyb"
    let url = URL(string: "https://api.mage.ai/v1/predict")!
    
    
    @IBOutlet weak var labelTxt: UILabel!
    @IBAction func predictButton(_ sender: Any) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
//        let jsonObject: [String: Any] = [
//            "api_key": "ilOxOhT4aZNgJ9XteGWyeKa3hpnQ2hZggna3Ucyb",
//            "features": [
//              [
//                "diameter": "0.5",
//                "height": "0.5",
//                "rings": "0.5",
//                "shell_weight": "0.5",
//                "shucked_weight": "0.5",
//                "viscera_weight": "0.5"
//              ]
//            ],
//            "model": "custom_prediction_regression_1645342113946",
//            "version": "1"
//        ]
        
        var c = 40.0
        var f = 20.0
        var p = 140.0
        var electrolytes = 2000.0
        var vitamins = 100.0
        var calories = 50.0
        
        c = Double(carbsTxt.text!)!
        f = Double(fatTxt.text!)!
        p = Double(proteinTxt.text!)!
        electrolytes = Double(electrolyteTxt.text!)!
        vitamins = Double(vitaminTxt.text!)!

        calories = c * 4 + f * 9 + p * 4
        
        caloriesTxt.text = "\(calories) cal"
    
        
        var caloriescore = 2000.0
        var electroscore = 2000.0
        var vitascore = 2000.0
        
        if calories < 2000 {
            caloriescore = calories / 20
        }
        else {
            caloriescore = (4000 - calories)/20
        }
        
        if electrolytes <= 3000 {
            electroscore = electrolytes / 30
        }
        else {
            electroscore = (6000 - electrolytes)/30
        }
        
        if vitamins <= 100 {
            vitascore = vitamins
        }
        else {
            vitascore = ((5 * (300 - vitamins)).squareRoot() / (2).squareRoot()) + 50
        }
        
//        caloriescore = 1.0
//        electroscore = 100.0
//        vitascore = 100.0
        
        
        let jsonObject: [String: Any] = [
        "api_key": "vjzOpi3r6Iah7Dly7GpXsrF8sJxGvGHrU8OZrEeo",
        "features": [
          [
            "c": "$\(c)",
            "caloriescore": "$\(caloriescore)",
            "calories": "$\(calories)",
            "electrolytes": "$\(electrolytes)",
            "electroscore": "$\(electroscore)",
            "f": "$\(f)",
            "p": "$\(p)",
            "vitamins__dv": "$\(vitamins)",
            "vitascore": "$\(vitascore)"
          ]
        ],
        "model": "custom_prediction_classification_1645326387647",
        "version": "1"
        ]
      
        
        let valid = JSONSerialization.isValidJSONObject(jsonObject) // true
        
        let bodyData = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: []
        )
        
        request.httpBody = bodyData
        
//        struct mageResponse: Codable {
//            var model_used: Bool
//            var prediction: Double
//            var uuid: String
//        }
        
        struct mageResponse: Decodable {
            let prediction: Int
        }
        
        // Create the HTTP request
        let session = URLSession.shared
        
/*
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
                print("error")
            } else if let data = data {
//                print(json["data"] as? [String:Any])
//                let jsonData = response.data(using: .utf8)
//                let filmSummary = try? JSONDecoder().decode(mageResponse.self, from: data)
                guard let responses: [mageResponse] = try! JSONDecoder().decode([mageResponse].self, from: data)
//                print(String(data: data, encoding: .utf8)!)
                print(responses.first?.prediction)
                
                let someStr = (String(data: data, encoding: .utf8)!)
//                for i in someStr{
//                    if (i ==32){}
//
//                }
                               
                let shorterStr = someStr.dropFirst(33)
               
                let someShortStr = String(shorterStr.prefix(10))
//                let someNum = Int(someShortStr)
                
                print("Prediction Score:" + someShortStr)
                
                
                
               // var someVar = someDict["prediction"]
                                
//               print(String(data: data, encoding: .utf8)!)
                
//                print()
            } else {
                // Handle unexpected error
                print("unexpected error")
              
            }
           
           
            
        }
        
 */
        var semaphore = DispatchSemaphore (value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            
            semaphore.signal()
            return
          }
//          print(String(data: data, encoding: .utf8)!)
            let responses: [mageResponse] = try! JSONDecoder().decode([mageResponse].self, from: data)
//            print(responses.first?.prediction)
            
//            nutritionTxt.text = String(responses.first?.prediction)
            
            let someStr = (String(data: data, encoding: .utf8)!)
//                for i in someStr{
//                    if (i ==32){}
//
//                }
                           
            let shorterStr = someStr.dropFirst(33)
           
            let someShortStr = String(shorterStr.prefix(1))
//                let someNum = Int(someShortStr)
            
            self.wellnessTxt.text = someShortStr
            print("Prediction Score:" + someShortStr)
          semaphore.signal()
        }
        
        task.resume()
        semaphore.signal()
       
            
        
    }
    
    
}

