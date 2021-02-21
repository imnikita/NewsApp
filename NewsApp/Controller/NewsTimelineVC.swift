//
//  NewsTimelineVC.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import UIKit
import SwiftyJSON
import SafariServices


class NewsTimelineVC: UIViewController{
    
    var pageNumber = 1
    var baseURL = "https://newsapi.org/v2/top-headlines?country=ua&apiKey=534ac317a6df498aab7b6bfe0c76d0fb&pageSize=15&page="
    
    var requestManager = RequestManager()
    var articlesArray = [NewsModel]()

    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var newsTimelineTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        requestManager.getData(withURL: baseURL, pageNumber: pageNumber)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlesArray = []
        newsTimelineTable.reloadData()
        newsTimelineTable.dataSource = self
        newsTimelineTable.delegate = self
        requestManager.delegate = self
        newsTimelineTable.rowHeight = 175
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTimelineTable.addSubview(refreshControl)
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        pageNumber = 1
        viewDidLoad()
        refreshControl.endRefreshing()
    }

    
}


// MARK: - Extension UITableViewDelegate methods

extension NewsTimelineVC: UITableViewDataSource, UITableViewDelegate {
    
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
     
    
    
    func didUpdateData(_ weatherManager: RequestManager, jsonData: JSON) {
        
        var authorSubstring: String?
        
        for article in 0...jsonData["articles"].count{
            authorSubstring = jsonData["articles"][article]["author"].string ?? "Article from editor"
            authorSubstring = authorVerification(autorStr: authorSubstring!)
            
            if let publishedTime = jsonData["articles"][article]["publishedAt"].string,
               let title = jsonData["articles"][article]["title"].string,
               let urlToImage = jsonData["articles"][article]["urlToImage"].url,
               let urlToSite = jsonData["articles"][article]["url"].url{
                let formatedTime = publishedTime.dateStrFormating()
                let article = NewsModel(author: authorSubstring, title: title, postTime: formatedTime, urlToImage: urlToImage, urlToSite: urlToSite)
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




