//
//  RequestManager.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import Foundation
import SwiftyJSON


//protocol RequestMamagerDelegate {
//    func didUpdateWeather(_ weatherManager: RequestManager, weather: NewsModel)
//    func didFailWithError(error: Error)
//}



struct RequestManager{
    
    
    func getData(){
    let initialUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=4e85f6e8b5f5497cb1e115bbbd64e9c2")
        
        let request = URLRequest(url: initialUrl!)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            if let saveData = data{
                do{
                    let json = try JSON(data: saveData)
//                    print(json)
                }
                catch{
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    
    func parceJSON(from json: JSON){
        
        
        
    }
    
    
    
}