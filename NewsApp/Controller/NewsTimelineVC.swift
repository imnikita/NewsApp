//
//  NewsTimelineVC.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import UIKit
import SwiftyJSON

class NewsTimelineVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var requestManager = RequestManager()
    var articlesArray = [NewsModel]()
    

    @IBOutlet weak var newsTimelineTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTimelineTable.dataSource = self
        newsTimelineTable.delegate = self
        requestManager.delegat = self
        newsTimelineTable.rowHeight = 175
        requestManager.getData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articlesArray.count
    }
    

    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsCell{
            cell.newsTime.text = articlesArray[indexPath.row].postTime
            cell.newsTitle.text = articlesArray[indexPath.row].title
            cell.authorNameAndSource.text = articlesArray[indexPath.row].author
            cell.newsImage.load(url: articlesArray[indexPath.row].urlToImage!)
            
            let viewSeparatorLine = UIView(frame:CGRect(x: 0, y: cell.contentView.frame.size.height - 8.0, width: cell.contentView.frame.size.width, height: 8))
            cell.contentView.addSubview(viewSeparatorLine)
            
            return cell
        }else{
            return NewsCell()
        }
    }
}

extension NewsTimelineVC: RequestMamagerDelegate{
    func didUpdateWeather(_ weatherManager: RequestManager, jsonData: JSON) {
        //        print("first \(jsonData["articles"].count)")
        for article in 0...jsonData["articles"].count{
            if let publishedTime = jsonData["articles"][article]["publishedAt"].string,
               let title = jsonData["articles"][article]["title"].string,
               let source = jsonData["articles"][article]["source"]["name"].string,
               let author = jsonData["articles"][article]["author"].string,
               let urlToImage = jsonData["articles"][article]["urlToImage"].url{
                let article = NewsModel(source: source, author: author, title: title, postTime: publishedTime, urlToImage: urlToImage)
                self.articlesArray.append(article)
            }
        }
        DispatchQueue.main.async {
            self.newsTimelineTable.reloadData()
            print(self.articlesArray)
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

