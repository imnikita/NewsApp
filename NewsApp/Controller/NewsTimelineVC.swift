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
//        newsTimelineTable.tableFooterView = UIView(frame: .zero)
        
        requestManager.getData(withURL: baseURL, pageNumber: pageNumber)
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTimelineTable.addSubview(refreshControl)
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        viewDidLoad()
        refreshControl.endRefreshing()
    }
    
    
    @IBAction func buttonIsPressed(_ sender: Any) {
        print("---------------------------------------------------")
        print(pageNumber)
        requestManager.getData(withURL: baseURL, pageNumber: pageNumber)
        pageNumber += 1
        print(pageNumber)
        print("---------------------------------------------------")
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
//            if indexPath.row == articlesArray.count - 1{
//                requestManager.getData(withURL: baseURL, pageNumber: pageNumber)
//                pageNumber += 1
//            }
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




