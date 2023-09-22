//
//  File.swift
//  Photo search
//
//  Created by Vlad Klunduk on 22/09/2023.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let regular: String
}
