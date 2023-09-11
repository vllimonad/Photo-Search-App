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
    let regular: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    var collectionView: UICollectionView?
    let searchBar = UISearchBar()
    var results: [Result] = []
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayout()
    }
    
    func addSubviews() {
        layout.itemSize = CGSize(width: view.frame.width/2 - 2.5, height: view.frame.width/2 - 2.5)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView?.dataSource = self
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(collectionView!)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            collectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView!.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            results = []
            collectionView?.reloadData()
            fetchPhotos(query: text.replacingOccurrences(of: " ", with: "_"))
        }
    }
    
    func fetchPhotos(query: String) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=1&per_page=30&query=\(query)&client_id=2rhIwZpbY0sT_eX-_qRTkX4ED2zRmDZvw5JB8X77hQY") else { return }
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
        let imageURLString = results[indexPath.row].urls.regular
        cell.configure(imageURLString)
        return cell
    }
}

