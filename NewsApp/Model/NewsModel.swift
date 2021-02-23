//
//  News.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import Foundation

struct NewsModel{
    public var author: String?
    private(set) public var title: String?
    private(set) public var postTime: String?
    private(set) public var urlToImage: URL?
    private(set) public var urlToSite: URL?
    private(set) public var totalResults: Int?
}
