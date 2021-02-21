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

    func getData(withURL url: String, pageNumber: Int){
        
        let requestUrl = URL(string: url + String(pageNumber))
        
        let request = URLRequest(url: requestUrl!)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let saveData = data{
                do{
                    let json = try JSON(data: saveData)
                    print(json)
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
