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
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var newsTimelineTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTimelineTable.dataSource = self
        newsTimelineTable.delegate = self
        requestManager.delegate = self
        newsTimelineTable.rowHeight = 175
        requestManager.getData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTimelineTable.addSubview(refreshControl)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        requestManager.getData()
        refreshControl.endRefreshing()
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
        articlesArray = []
        var authorSubstring: String?

        
        for article in 0...jsonData["articles"].count{
            authorSubstring = jsonData["articles"][article]["author"].string ?? "Article from editor"
            authorSubstring = authorVerification(autorStr: authorSubstring!)
//            authorSubstring = authorSubstring?.truncateAll(after: "[")
//            authorSubstring = authorSubstring?.truncateAll(after: "https:")
//            authorSubstring = authorSubstring != "" ? authorSubstring : "Article from editor"
            
            if let publishedTime = jsonData["articles"][article]["publishedAt"].string?.dateStrFormating(),
               let title = jsonData["articles"][article]["title"].string,
               let urlToImage = jsonData["articles"][article]["urlToImage"].url,
               let urlToSite = jsonData["articles"][article]["url"].url{
                let article = NewsModel(author: authorSubstring, title: title, postTime: publishedTime, urlToImage: urlToImage, urlToSite: urlToSite)
                self.articlesArray.append(article)
            }
        }
        DispatchQueue.main.async {
            self.newsTimelineTable.reloadData()
        }
    }
    

    
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

