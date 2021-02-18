//
//  NewsCellVC.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var authorNameAndSource: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.5725490196, blue: 0.6862745098, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 5
        newsTitle.adjustsFontSizeToFitWidth = true
        self.selectionStyle = .none
    }
}
