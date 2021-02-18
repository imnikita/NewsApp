//
//  extensions.swift
//  NewsApp
//
//  Created by Nikita Popov on 17.02.2021.
//

import UIKit



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension String{
    func truncateAll(after char: String) -> String{
                var title = ""
                if !self.contains(char){
                    return self
                }else if let index = self.range(of: char)?.lowerBound {
                    let substring = self[..<index]
                    title = String(substring)
                }
                return title
    }


    func dateStrFormating() -> String{
        var dateToReturn = self.truncateAll(after: ".")
        dateToReturn = dateToReturn.replacingOccurrences(of: "T", with: " ")
         
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "dd.MM.yyyy HH:mm"
       
        let date = dateFormatterGet.date(from: dateToReturn)
        return dateFormatterSet.string(from: date ?? Date())
    }
    
}


// MARK: - Global functions

func authorVerification(autorStr: String) -> String?{
    var author = autorStr.truncateAll(after: "[").truncateAll(after: "https:")
    author = author != "" ? author : "Article from editor"
    return author
}
