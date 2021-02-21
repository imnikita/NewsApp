//
//  RequestManager.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import Foundation
import SwiftyJSON


protocol RequestMamagerDelegate {
    func didUpdateData(_ requestManager: RequestManager, jsonData: JSON)
    func didFailWithError(error: Error)
}



struct RequestManager{
    
    var delegate: RequestMamagerDelegate?
    
    private let baseURL = "https://newsapi.org/v2/"
    private let apiKey = "API_Key"
    
    func getData(){
        
    let initialUrl = URL(string: "\(baseURL)top-headlines?country=ua&apiKey=\(apiKey)&pageSize=80")
        
        let request = URLRequest(url: initialUrl!)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let saveData = data{
                do{
                    let json = try JSON(data: saveData)
//                    print(json)
                    self.delegate?.didUpdateData(self, jsonData: json)
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
}
