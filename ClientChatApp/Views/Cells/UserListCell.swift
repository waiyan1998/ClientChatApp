//
//  UserListCell.swift
//  ClientChatApp
//
//  Created by  Brycen Myanmar  on 31/05/2024.
//

import UIKit

class UserListCell: UITableViewCell {
    
    
    
    @IBOutlet weak var PeopleCollectionView : UICollectionView!{
        didSet {
            self.PeopleCollectionView.delegate = self
            self.PeopleCollectionView.dataSource = self
            self.PeopleCollectionView.registerForCell(strID: PeopleCell.identifier)
        }
    }
    
    var data : [User]  = [] {
        didSet {
            self.PeopleCollectionView.reloadData()
        }
    }
    


    override func awakeFromNib() {
        super.awakeFromNib()
        if let layout = PeopleCollectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout{
            layout.horizontalAlignment = .left
        }
        // Initialization code
        UsersViewModel.shared.getUserLists()
        setupBindings()
        
    }
    
    private func setupBindings() {
        
        UsersViewModel.shared.$userlists
            .receive(on: RunLoop.main)
            .sink { [weak self] lists in
                self?.data = lists
            }
            .store(in: &UsersViewModel.shared.cancellables)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UserListCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleCell.identifier, for: indexPath) as! PeopleCell
        cell.data = self.data[indexPath.row]
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 60, height: 60)
//    }
    
}
