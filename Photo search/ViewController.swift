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

class ViewController: UIViewController, UICollectionViewDataSource {
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        return layout
    }()
    
    var collectionView: UICollectionView?
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=office&client_id=2rhIwZpbY0sT_eX-_qRTkX4ED2zRmDZvw5JB8X77hQY"

    var results: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
        fetchPhotos()
    }
    
    func createCollectionView() {
        layout.itemSize = CGSize(width: view.frame.width/2 - 2.5, height: view.frame.width/2 - 2.5)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView?.frame = view.bounds
        
        view.addSubview(collectionView!)
    }
    
    func fetchPhotos() {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                    print(jsonResult.results.count)
                }
            } catch {
                print("error")
            }
        }
        task.resume()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        let imageURLString = results[indexPath.row].urls.full
        cell.configure(imageURLString)
        return cell
    }
}

