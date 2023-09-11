//
//  ViewController.swift
//  Photo search
//
//  Created by Vlad Klunduk on 10/09/2023.
//

import UIKit

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
    let full: String
}

class ViewController: UIViewController {
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=office&client_id=2rhIwZpbY0sT_eX-_qRTkX4ED2zRmDZvw5JB8X77hQY"

    var results: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    print(jsonResult.results.count)
                }
            } catch {
                print("error")
            }
        }
        task.resume()
    }


}

