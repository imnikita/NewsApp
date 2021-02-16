//
//  NewsCellVC.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsTitleAndResource: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
