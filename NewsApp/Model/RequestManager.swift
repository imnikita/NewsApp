//
//  RequestManager.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import Foundation
import SwiftyJSON


protocol RequestMamagerDelegate {
    func didUpdateWeather(_ weatherManager: RequestManager, jsonData: JSON)
    func didFailWithError(error: Error)
}



struct RequestManager{
    
    
    var delegate: RequestMamagerDelegate?
    
    private let baseURL = "https://newsapi.org/v2/"
    private let apiKey = "4e85f6e8b5f5497cb1e115bbbd64e9c2"
    
    func getData(){
        
    let initialUrl = URL(string: "\(baseURL)top-headlines?country=us&apiKey=\(apiKey)&pageSize=80")
        
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
                    self.delegate?.didUpdateWeather(self, jsonData: json)
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
}
