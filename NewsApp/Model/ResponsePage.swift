//
//  ResponsePage.swift
//  NewsApp
//
//  Created by Nikita Popov on 21.02.2021.
//

import Foundation

import PaginationController

struct ResponsePage: Page {
    var count: Int
    var page: Int
    var pageSize: Int
    var results: [NewsModel]
}

extension ResponsePage {

    var hasNextPage: Bool {
        return ((page + 1) * pageSize) + results.count < count
    }
}
