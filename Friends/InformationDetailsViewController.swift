//
//  InformationDetailsViewController.swift
//  Friends
//
//  Created by MacBook Pro on 21/5/21.
//

import UIKit

class InformationDetailsViewController: UIViewController {
    @IBOutlet weak var friendsImage: UIImageView!
    @IBOutlet weak var friendsInformatios: UILabel!
    @IBOutlet weak var DetailsCollectionView: UICollectionView!
    var frienfList: Result?
    
    
    var settingsMenuDataSource: [(title: String, imageName: String, identifier: String)] = [("Full Name","Person", identifier: "name"),("Gmail","Email", identifier: "gmail"),("Date of Birth","Calendar", identifier: "dob"),("Address","Address", identifier: "address"),("Phone","Contact", identifier: "phone")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = frienfList?.picture?.large {
            friendsImage.downloaded(from: photo)
        }
        DetailsCollectionView.dataSource = self
        DetailsCollectionView.delegate = self
      
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = frienfList
        let item2 = settingsMenuDataSource [indexPath.row]
       
        if item2.identifier == "name"{
            friendsInformatios.text =  item?.name?.first
        }
        if item2.identifier == "gmail"{
            friendsInformatios.text = item?.email
            if let email = item?.email{
                let appURL = URL(string: "mailto:\(email)")!

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
           
        }
        if item2.identifier == "dob"{
            friendsInformatios.text = item?.dob?.date
        }
        if item2.identifier == "address"{
            friendsInformatios.text = item?.location?.country
        }
        if item2.identifier == "phone"{
            friendsInformatios.text = item?.phone
        }
        
    }

}

extension InformationDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  settingsMenuDataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item =  self.settingsMenuDataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsListDetailsCollectionViewCell", for: indexPath) as! FriendsListDetailsCollectionViewCell
        cell.friendsPhoto.image = UIImage(named: item.imageName)
        cell.friendsFullName.text = item.title
        return cell
    }
    
    
}


class FriendsListDetailsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var friendsPhoto: UIImageView!
    @IBOutlet weak var friendsFullName: UILabel!
    @IBOutlet weak var friendsCountry: UILabel!
    
}


