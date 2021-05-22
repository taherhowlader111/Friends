//
//  ViewController.swift
//  Friends
//
//  Created by MacBook Pro on 21/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    var frienfList:[ Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        getRequest()
    }
    
    func getRequest() {
        let url: String = "https://randomuser.me/api/"
        var components = URLComponents(string: url)!
        
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error,
                return
            }
            
            do {
                let modelData = try JSONDecoder().decode(Welcome.self, from: data)
                print(modelData)
                self.frienfList = modelData.results ?? []
                DispatchQueue.main.async {
                    self.CollectionView.reloadData()
                }
                
            } catch (let err){
                print(err.localizedDescription)
            }
            
        }
        task.resume()
    }
    
   
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frienfList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item =  self.frienfList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsListCollectionViewCell", for: indexPath) as! FriendsListCollectionViewCell
        var  title:String = item.name?.title ?? ""
        var firstName:String = item.name?.first ?? ""
        var lastName:String = item.name?.last ?? ""
        cell.friendsFullName.text = "\(title) \(firstName) \(lastName)"
        cell.friendsCountry.text = item.location?.country
        if let photo = item.picture?.thumbnail {
            cell.friendsPhoto.downloaded(from: photo)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.frienfList[indexPath.row]
        let storyBoad = UIStoryboard(name: "Main", bundle: Bundle.main)
        let TransferVC = storyBoad.instantiateViewController(withIdentifier: "InformationDetailsViewController") as? InformationDetailsViewController
        TransferVC?.frienfList = item
        self.navigationController?.show(TransferVC!, sender: nil)
        
        
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class FriendsListCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var friendsPhoto: UIImageView!
    @IBOutlet weak var friendsFullName: UILabel!
    @IBOutlet weak var friendsCountry: UILabel!
    
}

