//
//  News.swift
//  NewsApp
//
//  Created by Nikita Popov on 16.02.2021.
//

import Foundation

struct NewsModel{
    private(set) public var source: String?
    private(set) public var author: String?
    private(set) public var title: String?
    private(set) public var postTime: String?
    private(set) public var urlToImage: URL?
    private(set) public var urlToSite: URL?
}
