//
//  NewsTimelineVC.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import UIKit
import SwiftyJSON
import SafariServices

class NewsTimelineVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var requestManager = RequestManager()
    var articlesArray = [NewsModel]()
    
    @IBOutlet weak var newsTimelineTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTimelineTable.dataSource = self
        newsTimelineTable.delegate = self
        requestManager.delegate = self
        newsTimelineTable.rowHeight = 175
        requestManager.getData()
    }
    
    
    
// MARK: - UITableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
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
            return cell
        }else{
            return NewsCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let safeData = articlesArray[indexPath.row].urlToSite{
            let vc = SFSafariViewController(url: safeData)
            present(vc, animated: true, completion: nil)
        }
    }
    
}



// MARK: - RequestMamagerDelegate extension

extension NewsTimelineVC: RequestMamagerDelegate{
    func didUpdateWeather(_ weatherManager: RequestManager, jsonData: JSON) {
        for article in 0...jsonData["articles"].count{
            if let publishedTime = jsonData["articles"][article]["publishedAt"].string,
               let title = jsonData["articles"][article]["title"].string,
               let source = jsonData["articles"][article]["source"]["name"].string,
               let author = jsonData["articles"][article]["author"].string,
               let urlToImage = jsonData["articles"][article]["urlToImage"].url,
               let urlToSite = jsonData["articles"][article]["url"].url{
                let article = NewsModel(source: source, author: author, title: title, postTime: publishedTime, urlToImage: urlToImage, urlToSite: urlToSite)
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

