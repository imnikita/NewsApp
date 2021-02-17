//
//  NewsTimelineVC.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import UIKit

class NewsTimelineVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let dataManager = RequestManager()
    

    @IBOutlet weak var newsTimelineTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTimelineTable.dataSource = self
        newsTimelineTable.delegate = self
    
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsCell
        return cell
    }

}

